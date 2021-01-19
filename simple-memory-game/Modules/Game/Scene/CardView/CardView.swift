//
//  CardCollectionViewCell.swift
//  simple-memory-game
//
//  Created by MSI on 19.01.2021.
//

import UIKit

class CardView: UIView, UserInteractionHandler {
    
    // MARK: - UI Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: Button! { didSet { self.button.setNext(handler: self) } }
    
    // MARK: - Properties
    
    var model = CardModel()
    
    // MARK: - Inits and configs methods
    
    func configure(cardModel: CardModel) {
        self.model = cardModel
    }
    
    private func flip() {
        if model.isFlipped {
            UIView.transition(with: self, duration: 0.4, options: .transitionFlipFromLeft, animations: {
                self.imageView.image = self.model.image
                self.imageView.layer.cornerRadius = 0.0
            })
            
            model.isFlipped = true
        } else {
            UIView.transition(with: self, duration: 0.4, options: .transitionFlipFromRight, animations: {
                self.imageView.image = nil
                self.imageView.layer.cornerRadius = 2.0
            })
            
            model.isFlipped = false
        }
    }
    
    // MARK: - UserInteractionHandler
    
    func handle(controlEvents: UIControl.Event) {
        if controlEvents == .touchUpInside {
            if model.isClickable {
                flip()
            }
        }
    }
    
    var nextHandler: UserInteractionHandler?
    
    // MARK: - Action
    
    @IBAction func tabAction(_ sender: Any) {
        handle(controlEvents: .touchUpInside)
    }
}
