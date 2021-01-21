//
//  Coordinator.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import Foundation

protocol Coordinator : class {
    var childCoordinators : [Coordinator] { get set }
    func start()
}

extension Coordinator {
    
    func store(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func store(coordinators: [Coordinator]) {
        childCoordinators += coordinators
    }
    
    func free(coordinator: Coordinator) {
        childCoordinators.removeAll(where: { $0 === coordinator } )
    }
}

