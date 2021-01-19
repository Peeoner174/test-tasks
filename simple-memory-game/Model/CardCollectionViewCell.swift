//
//  CardCollectionViewCell.swift
//  simple-memory-game
//
//  Created by MSI on 19.01.2021.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell, UserInteractionHandler {
    
    // MARK: - UI Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: Button! { didSet { self.button.setNext(handler: self) } }
    
    // MARK: - Properties
    
    var isFlipped: Bool = false
    var image: UIImage?
    
    // MARK: - Inits and configs methods
    
    func configure(image: UIImage, isFlipped: Bool) {
        self.image = image
        self.isFlipped = isFlipped
    }
    
    private func flip() {
        if isFlipped {
            UIView.transition(with: self, duration: 0.4, options: .transitionFlipFromLeft, animations: {
                self.imageView.image = self.image
                self.imageView.layer.cornerRadius = 0.0
            })
            
            isFlipped = true
        } else {
            UIView.transition(with: self, duration: 0.4, options: .transitionFlipFromRight, animations: {
                self.imageView.image = nil
                self.imageView.layer.cornerRadius = 2.0
            })
            
            isFlipped = false
        }
    }
    
    // MARK: - UserInteractionHandler
    
    func handle(controlEvents: UIControl.Event) {
        if controlEvents == .touchUpInside { flip() }
    }
    
    var nextHandler: UserInteractionHandler?
    
    // MARK: - Action
    
    @IBAction func tabAction(_ sender: Any) {
        handle(controlEvents: .touchUpInside)
    }
}
