//
//  PexesoCoordinator.swift
//  simple-memory-game
//
//  Created by MSI on 20.01.2021.
//

import Foundation
import UIKit

enum PexesoNavigation: Navigation {
    case start
    case game
}

protocol PexesoNavigationHandler: ViewController {
    func handle(_ navigation: PexesoNavigation)
}

class PexesoCoordinator: BaseCoordinator {
    let router: Router
    private let initialNavigation: PexesoNavigation
        
    init(router: Router, initialNavigation: PexesoNavigation) {
        self.router = router
        self.initialNavigation = initialNavigation
    }
    
    override func start() {
        getViewControllerAndRoute(initialNavigation) { drawable, router in
            router.presentAsRoot(drawable, isAnimated: false, setNavigationBarHidden: true)
        }
    }
    
    public func getViewControllerAndRoute(_ navigation: PexesoNavigation, routeBlock: (Drawable, Router) -> Void) {
        let vc: Drawable
        switch navigation {
        case .game:
            vc = DIContainer.resolve(PexesoComponent.self).gameViewController
        case .start:
            vc = DIContainer.resolve(PexesoComponent.self).startViewController
        }
        routeBlock(vc, router)
    }
}

