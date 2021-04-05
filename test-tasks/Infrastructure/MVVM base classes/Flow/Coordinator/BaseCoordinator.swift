//
//  BaseCoordinator.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import UIKit
import Combine

class BaseCoordinator: Coordinator, Drawable {
    
    var childCoordinators : [Coordinator] = []
    
    func start() -> AnyPublisher<Void, Never> {
        fatalError("Children should implement `start`.")
    }
    
    var viewController: ViewController? {
        fatalError("Children should implement viewController")
    }
}

