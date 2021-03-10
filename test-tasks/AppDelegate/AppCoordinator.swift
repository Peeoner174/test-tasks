//
//  AppCoordinator.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    let window : UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }

    override func start() {
        let pexesoStartCoordinator = PexesoStartCoordinator(router: RouterImpl(navigationController: NavigationController()))
        store(coordinator: pexesoStartCoordinator)
        pexesoStartCoordinator.start()
        
        window.rootViewController = pexesoStartCoordinator.rootViewController
        window.makeKeyAndVisible()
    }
}

