//
//  Button.swift
//  simple-memory-game
//
//  Created by MSI on 19.01.2021.
//

import UIKit

class Button: UIButton, UserInteractionHandler {
    weak var nextHandler: UserInteractionHandler?
    lazy var userInterationHandlerView: UIView = self.nextHandler as? UIView ?? self
    
    func handle(controlEvents: UIControl.Event) { }
    
    @IBInspectable var fontStyle: String = "regular" {
        didSet {
            unimplemented()
        }
    }
    
    @IBInspectable var fontSize: CGFloat = 12 {
        didSet {
            self.titleLabel?.font.withSize(self.fontSize)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 2 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if !self.isEnabled {
                backgroundColor = backgroundColor?.withAlphaComponent(0.5)
            } else {
                backgroundColor = backgroundColor?.withAlphaComponent(1.0)
            }
        }
    }
}

// MARK: - Actions

extension Button {
    
    override func sendActions(for controlEvents: UIControl.Event) {
        super.sendActions(for: controlEvents)
        self.handle(controlEvents: controlEvents)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        normalScale()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        normalScale()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        smallScale()
    }
}

// MARK: Animations

extension Button {
    
    func smallScale() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.userInterationHandlerView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    
    func normalScale() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.userInterationHandlerView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
}

