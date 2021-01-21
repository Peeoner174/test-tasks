//
//  TestTasksListCoordinator.swift
//  simple-memory-game
//
//  Created by MSI on 20.01.2021.
//

import Foundation
import UIKit

enum TestTasksListNavigation: Navigation {
    case main
    case pexeso
}

protocol TestTasksListNavigationHandler: ViewController {
    func handle(_ navigation: TestTasksListNavigation)
}

class TestTasksListCoordinator: BaseCoordinator {
    let router: Router
    private let initialNavigation: TestTasksListNavigation
        
    init(router: Router, initialNavigation: TestTasksListNavigation) {
        self.router = router
        self.initialNavigation = initialNavigation
    }
    
    override func start() {
        getViewControllerAndRoute(initialNavigation) { drawable, router in
            router.presentAsRoot(drawable, isAnimated: false, setNavigationBarHidden: true)
        }
    }
    
    public func getViewControllerAndRoute(_ navigation: TestTasksListNavigation, routeBlock: (Drawable, Router) -> Void) {
        let vc: Drawable
        switch navigation {
        case .pexeso:
            vc = DIContainer.resolve(PexesoComponent.self).gameViewController
        case .main:
            vc = DIContainer.resolve(TestTaskListComponent.self).mainViewController
        }
        routeBlock(vc, router)
    }
}
