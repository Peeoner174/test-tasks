//
//  CardsHolderView.swift
//  test-tasks
//
//  Created by MSI on 19.01.2021.
//

import UIKit
import Combine

// MARK: Delegate

protocol CardsHolderViewDelegate: class {
    func restartButtonTapped()
}

class CardsHolderView: XibView {
    private var bindings = Set<AnyCancellable>()
    
    weak var delegate: CardsHolderViewDelegate?
    
    // MARK: - UI Properties

    @IBOutlet weak var stackView: UIStackView!
    private var stackViewRows: [UIStackView] = []
        
    @IBOutlet weak var movesLabel: Label!
    
    @IBOutlet weak var foundedPairLabel: Label!
    
    @IBOutlet weak var leftPairLabel: Label!
    
    @IBOutlet weak var restartButton: UIButton!
    
    // MARK: - Properties
    
    private var movesCounter: Int = 0 {
        didSet {
            self.movesLabel.setFormattedText(String(self.movesCounter))
        }
    }
    
    private(set) var dataModel: CurrentValueSubject<[Card]> = .init([]) {
        didSet {
            self.initCards()
            self.bindDataModel()
        }
    }
    
    private(set) var uiConfig = CardsHolderView.UI() {
        didSet {
            onUIConfigUpdated()
        }
    }
    
    private var cardViewPairForCheck = Pair<CardView>() {
        didSet {
            self.cardViewPairForCheck.onPairCompleteClosure = { [weak self] first, second in
                guard let self = self else { return }
                let firstIndex = first.dataModel.refKey
                let secondIndex = second.dataModel.refKey
                let indexes = [firstIndex, secondIndex]
                
                if self.dataModel.value[firstIndex].image == self.dataModel.value[secondIndex].image {
                    indexes.forEach {
                        self.dataModel.value[$0].isClickable = false
                        self.dataModel.value[$0].isFlipped = true
                    }
                } else {
                    indexes.forEach {
                        self.dataModel.value[$0].isClickable = true
                        self.dataModel.value[$0].isFlipped = false
                    }
                }
                first.updateAnimated(model: self.dataModel.value[firstIndex])
                second.updateAnimated(model: self.dataModel.value[secondIndex])
            }
        }
    }

    // MARK: - Inits and configs methods
    
    func configure(with cards: CurrentValueSubject<[Card]>, uiConfig: CardsHolderView.UI? = nil, delegate: CardsHolderViewDelegate? = nil) {
        self.dataModel = cards
        self.uiConfig = uiConfig ?? CardsHolderView.UI()
        self.delegate = delegate
    }
    
    // MARK: - Actions
    
    @IBAction func restartAction(_ sender: Any) {
        delegate?.restartButtonTapped()
        self.movesCounter = 0
        cardViewPairForCheck = Pair<CardView>()
        self.initCards()
    }
    
    // MARK: - Priate methods
    
    private func bindDataModel() {
        dataModel.assertNoFailure().sink { [weak self] cards in
            guard let self = self else { return }
            
            let countedSet = NSCountedSet(array: cards.filter { $0.isFlipped }.compactMap { card in
                card.image
            })
            let foundedPair = countedSet.allObjects.reduce(into: 0) { result, element in
                if countedSet.count(for: element) > 1 {
                    result += 1
                }
            }
            self.foundedPairLabel.setFormattedText(String(foundedPair))
            self.leftPairLabel.setFormattedText( String((cards.count - foundedPair * 2) / 2) )
        }.store(in: &bindings)
    }
    
    private func initCards() {
        var cardsRows: [[CardView]] = []
        defer {
            stackView.removeAllArrangedSubviews()
            cardsRows.forEach {
                stackView.addArrangedSubview(createRow(with: $0))
            }
        }
        let cards = dataModel.value
        guard !cards.isEmpty else { return }
        
        let squareRootOfCardsCount = sqrt(Double(cards.count))
        
        let numberOfRow: Int = {
            squareRootOfCardsCount.truncatingRemainder(dividingBy: 1) > 0 ? Int(squareRootOfCardsCount) + 1 : Int(squareRootOfCardsCount)
        }()
        
        let numberOfColumns: Int =  {
            (Int(squareRootOfCardsCount) * numberOfRow) == cards.count ? Int(squareRootOfCardsCount) : Int(squareRootOfCardsCount) + 1
        }()
        
        for rowIndex in 0..<numberOfRow {
            var newRowCards: [CardView] = []
            
            let startIndexRange = numberOfColumns * rowIndex
            let endIndexRange = startIndexRange + (numberOfColumns - 1)
            
            for index in startIndexRange...endIndexRange {
                guard let cardModel = cards[guarded: index] else {
                    let noActiveCardModel = Card(
                        refKey: cardsRows.flatMap {$0}.count + newRowCards.count + 1,
                        isFlipped: false,
                        image: nil,
                        isClickable: false
                    )
                    let cardView = CardView()
                    
                    cardView.configure(with: noActiveCardModel, uiConfig: CardView.UI(isActive: false))
                    newRowCards.append(cardView)
                    continue
                }
                let cardView = CardView()
                cardView.configure(with: cardModel, delegate: self)
                newRowCards.append(cardView)
            }
            cardsRows.append(newRowCards)
        }
    }
        
    private func createRow(with cards: [CardView]) -> UIStackView {
        let row: UIStackView = {
            let sv = UIStackView()
            sv.axis = .horizontal
            sv.alignment = .fill
            sv.distribution = .fillEqually
            sv.spacing = uiConfig.spacing
            sv.contentMode = .scaleAspectFit
            sv.translatesAutoresizingMaskIntoConstraints = false
            return sv
        }()
        cards.forEach { row.addArrangedSubview($0) }
        stackViewRows.append(row)
        
        return row
    }
}

// MARK: - CardViewDelegate

extension CardsHolderView: CardViewDelegate {
    func cardViewDidTapped(_ cardView: CardView, withModel model: Card) {
        dataModel.value[model.refKey] = model
        cardViewPairForCheck.append(cardView)
        self.movesCounter += 1
    }
}

// MARK: - UI

extension CardsHolderView {
    struct UI {
        let spacing: CGFloat = 5.0
    }
    
    private func onUIConfigUpdated() {
        self.stackView.spacing = uiConfig.spacing
        for index in 0..<stackViewRows.count {
            stackViewRows[index].spacing = uiConfig.spacing
        }
    }
}

