//
//  BaseCoordinator.swift
//  simple-memory-game
//
//  Created by MSI on 20.01.2021.
//

import UIKit

class BaseCoordinator : Coordinator {
    var childCoordinators : [Coordinator] = []

    var isCompleted: (() -> ())?
    
    func start() {
        fatalError("Children should implement `start`.")
    }
}

extension BaseCoordinator: Injector {}

