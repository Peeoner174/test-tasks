//
//  CardCollectionViewCell.swift
//  test-tasks
//
//  Created by MSI on 19.01.2021.
//

import UIKit
import Combine

// MARK: - Delegate

protocol CardViewDelegate: AnyObject {
    func cardViewDidTapped(_ cardView: CardView, withModel model: Card)
}

class CardView: XibView, UserInteractionHandler {
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: Button! { didSet { self.button.setNext(handler: self) } }
    
    // MARK: - Properties
    
    weak var delegate: CardViewDelegate?
    private(set) var dataModel: Card = Card(refKey: 0)
    private(set) var uiConfig = CardView.UI() { didSet { onUIConfigUpdated() } }
    
    // MARK: - Inits and configs methods
    
    func configure(with card: Card, uiConfig: CardView.UI? = nil, delegate: CardViewDelegate? = nil) {
        self.dataModel = card
        self.uiConfig = uiConfig ?? CardView.UI()
        self.delegate = delegate
    }
    
    func updateAnimated(model: Card) {
        if model.isFlipped != self.dataModel.isFlipped {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
                self?.dataModel = model
                self?.flip()
            })
        }
    }
    
    // MARK: - Private methods
    
    private func flip() {
        
        if dataModel.isFlipped {
            UIView.transition(with: self, duration: 0.4, options: .transitionFlipFromLeft, animations: {
                self.setOpenViewState()
            })
        } else {
            UIView.transition(with: self, duration: 0.4, options: .transitionFlipFromRight, animations: {
                self.setClosedViewState()
            })
        }
    }
    
    private func setOpenViewState() {
        self.setImage()
        self.isUserInteractionEnabled = false
        
    }
    
    private func setClosedViewState() {
        self.imageView.image = nil
        self.isUserInteractionEnabled = true
    }
    
    private func setImage() {
        guard let imagePath = dataModel.image else { return }
        
        if let urlComponents = URLComponents(string: imagePath),
           (urlComponents.scheme == "https" || urlComponents.scheme == "http")  {
            unimplemented()
        } else {
            self.imageView.image = UIImage(systemName: imagePath)
        }
    }
    
    // MARK: - UserInteractionHandler
    
    func handle(controlEvents: UIControl.Event) {
        if controlEvents == .touchUpInside {
            dataModel.isFlipped.toggle()
            flip()
            delegate?.cardViewDidTapped(self, withModel: dataModel)
        }
    }
    
    weak var nextHandler: UserInteractionHandler?
    
    // MARK: - Action
    
    @IBAction func tapAction(_ sender: Any) {
        handle(controlEvents: .touchUpInside)
    }
}

// MARK: - UI

extension CardView {
    struct UI {
        let borderWidth: CGFloat
        let cornerRadius: CGFloat
        let isActive: Bool
        
        init(borderWidth: CGFloat = 2.0, cornerRadius: CGFloat = 5.0, isActive: Bool = true) {
            self.borderWidth = borderWidth
            self.cornerRadius = cornerRadius
            self.isActive = isActive
        }
    }
    
    private func onUIConfigUpdated() {
        self.layer.borderWidth = uiConfig.borderWidth
        self.layer.cornerRadius = uiConfig.cornerRadius
        self.layer.borderColor = uiConfig.isActive ? UIColor.black.cgColor : UIColor.gray.cgColor
        self.isUserInteractionEnabled = uiConfig.isActive
    }
}
