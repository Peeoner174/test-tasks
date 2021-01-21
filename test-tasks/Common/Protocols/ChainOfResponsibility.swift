//
//  ChainOfResponsibility.swift
//  test-tasks
//
//  Created by MSI on 19.01.2021.
//

import UIKit

protocol UserInteractionHandler: UIResponder {
    @discardableResult
    func setNext(handler: UserInteractionHandler) -> UserInteractionHandler
    
    /// Must be weak
    var nextHandler: UserInteractionHandler? { get set }
    
    func handle(controlEvents: UIControl.Event)
}

extension UserInteractionHandler {
    
    @discardableResult
    func setNext(handler: UserInteractionHandler) -> UserInteractionHandler {
        self.nextHandler = handler
        return handler
    }
    
    func handle(controlEvents: UIControl.Event) {
        nextHandler?.handle(controlEvents: controlEvents)
    }
}
