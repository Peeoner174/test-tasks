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
    typealias DataModel = Array<Card>
    
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
    
    private(set) var dataModel = DataModel()
    
    private var movesCounter: Int = 0 {
        didSet {
            self.movesLabel.setFormattedText(String(self.movesCounter))
        }
    }
    
    private var foundedPairCounter: Int = 0 {
        didSet {
            self.foundedPairLabel.setFormattedText(String(self.foundedPairCounter))
            self.leftPairLabel.setFormattedText(String(self.leftPairCounter))
        }
    }
    
    private var leftPairCounter: Int {
        get {
            (dataModel.count - foundedPairCounter * 2) / 2
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
                
                if self.dataModel[firstIndex].image == self.dataModel[secondIndex].image {
                    indexes.forEach {
                        self.dataModel[$0].isClickable = false
                        self.dataModel[$0].isFlipped = true
                        self.refreshScore()
                    }
                } else {
                    indexes.forEach {
                        self.dataModel[$0].isClickable = true
                        self.dataModel[$0].isFlipped = false
                    }
                }
                first.updateAnimated(model: self.dataModel[firstIndex])
                second.updateAnimated(model: self.dataModel[secondIndex])
            }
        }
    }

    // MARK: - Lifecycle
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        movesCounter = 0
    }
    
    // MARK: - Public
    
    func configure(
        with dataModel: DataModel = [],
        uiConfig: CardsHolderView.UI? = nil,
        delegate: CardsHolderViewDelegate? = nil
    ) {
        self.dataModel = dataModel
        self.uiConfig = uiConfig ?? CardsHolderView.UI()
        self.delegate = delegate
        
        self.dataModelReload()
    }
    
    func dataModelUpdate(_ dataModel: DataModel) {
        self.dataModel = dataModel
        dataModelReload()
    }
    
    // MARK: - Actions
    
    @IBAction func restartAction(_ sender: Any) {
        delegate?.restartButtonTapped()
        self.movesCounter = 0
        cardViewPairForCheck = Pair<CardView>()
        self.dataModelReload()
    }
    
    // MARK: - Priate methods
    
    private func refreshScore() {
        self.foundedPairCounter = dataModel.filter { $0.isFlipped }.count
    }
    
    private func dataModelReload() {
        var cardsRows: [[CardView]] = []
        defer {
            foundedPairCounter = 0
            stackView.removeAllArrangedSubviews()
            cardsRows.forEach {
                stackView.addArrangedSubview(createRow(with: $0))
            }
        }
        let cards = dataModel
        guard !cards.isEmpty else { return }
        
        let squareRootOfCardsCount = sqrt(Double(cards.count))
        
        let numberOfRow: Int = {
            squareRootOfCardsCount.truncatingRemainder(dividingBy: 1) > 0 ? Int(squareRootOfCardsCount) + 1 : Int(squareRootOfCardsCount)
        }()
        
        let numberOfColumns: Int =  {
            (Int(squareRootOfCardsCount) * numberOfRow) >= cards.count ? Int(squareRootOfCardsCount) : Int(squareRootOfCardsCount) + 1
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
        dataModel[model.refKey] = model
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

