//
//  AppCoordinator.swift
//  simple-memory-game
//
//  Created by MSI on 20.01.2021.
//

import Foundation
import UIKit

enum AppNavigation {
    case pexeso
    case testTaskList
}

class AppCoordinator: BaseCoordinator {
    let window : UIWindow
    let router: Router
    let navigationController: NavigationController
    
    init(window: UIWindow, router: Router, navigationController: NavigationController) {
        self.window = window
        self.router = router
        self.navigationController = navigationController
        super.init()
    }

    override func start() {
        // Creating coordinators
        let pexesoCoordinator = PexesoCoordinator(router: router, initialNavigation: .start)
        let testTaskListCoordinator = TestTasksListCoordinator(router: router, initialNavigation: .main)

        store(coordinators: [pexesoCoordinator, testTaskListCoordinator])
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        getViewControllerAndRoute(.pexeso) { (drawable, router) in
            router.presentAsRoot(drawable, isAnimated: false, setNavigationBarHidden: true)
        }
    }
    
    public func getViewControllerAndRoute(_ navigation: AppNavigation, routeBlock: (Drawable, Router) -> Void) {
        let vc: Drawable
        switch navigation {
        case .pexeso:
            vc = DIContainer.resolve(PexesoComponent.self).startViewController
        case .testTaskList:
            vc = DIContainer.resolve(TestTaskListComponent.self).mainViewController
        }
        routeBlock(vc, router)
    }
}

