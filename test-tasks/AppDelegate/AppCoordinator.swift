//
//  AppCoordinator.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import UIKit
import Combine

class AppCoordinator: BaseCoordinator {
    let window : UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }

    override func start() -> AnyPublisher<Void, Never> {
        let coordinator = PexesoStartCoordinator()
        store(coordinator: coordinator)
                
        let coordinatorFinish = coordinator.start().handleEvents(receiveCompletion: { [weak self] _ in
            guard let self = self else { return }
            self.free(coordinator: coordinator)
        })
        
        window.rootViewController = coordinator.router.navigationController
        window.makeKeyAndVisible()
        
        return coordinatorFinish.eraseToAnyPublisher()
    }
}

