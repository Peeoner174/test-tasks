//
//  CardsHolderView.swift
//  simple-memory-game
//
//  Created by MSI on 19.01.2021.
//

import UIKit

class CardsHolderView: UIView {
    
    // MARK: - UI Properties

    @IBOutlet weak var stackView: UIStackView!
        
    // MARK: - Properties

    private(set) var cards: [CardModel] = [] {
        didSet {
            updateMatrixSize()
        }
    }
    private(set) var uiConfig = CardsHolderView.UI()
    
    typealias MatrixSize = (rows: Int, columns: Int)
    private var matrixSize: MatrixSize = (0, 0)

    // MARK: - Inits and configs methods

    func configure(cards: [CardModel], uiConfig: CardsHolderView.UI? = nil) {
        self.cards = cards
        self.uiConfig = uiConfig ?? CardsHolderView.UI()
    }
    
    private func initCards() {
        (0...matrixSize.rows).forEach { rowIndex in
            let newRow = createRow()
            
            let startIndexRange = (matrixSize.columns * rowIndex)
            let endIndexRange = startIndexRange + matrixSize.columns
            
            for index in startIndexRange...endIndexRange {
                let cardView = CardView()
                cardView.configure(cardModel: cards[index])
                newRow.addArrangedSubview(cardView)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func createRow() -> UIStackView {
        let row: UIStackView = {
            let sv = UIStackView()
            sv.axis = .horizontal
            sv.alignment = .fill
            sv.distribution = .fillEqually
            sv.spacing = uiConfig.spacing
            sv.contentMode = .scaleToFill
            sv.translatesAutoresizingMaskIntoConstraints = false
            return sv
        }()
        
        return row
    }
    
    private func updateMatrixSize() {
        var rows: Int = 0
        var columns: Int = 0
        
        for numberOfColumns in 4... {
            if cards.count / numberOfColumns > uiConfig.maxNumberOfRows {
                continue
            } else {
                rows = cards.count / numberOfColumns
                columns = numberOfColumns
                break
            }
        }
        self.matrixSize = (rows, columns)
    }
}

// MARK: - UI config

extension CardsHolderView {
    struct UI {
        let spacing: CGFloat = 2.0
    
        var maxNumberOfRows: Int {
            get {
                return Int((UIScreen.main.bounds.height / 2) / 50)
            }
        }
    }
}
