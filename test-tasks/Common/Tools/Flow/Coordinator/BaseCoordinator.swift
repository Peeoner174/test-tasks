//
//  BaseCoordinator.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import UIKit

class BaseCoordinator: Coordinator, Drawable {
    var navigationController: NavigationController?
    var childCoordinators : [Coordinator] = []

    var isCompleted: (() -> Void)?
    
    func start() {
        fatalError("Children should implement `start`.")
    }
    
    var viewController: ViewController? {
        fatalError("Children should implement viewController")
    }
}

