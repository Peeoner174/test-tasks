//
//  PexesoGameCoordinator.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 10.03.2021.
//

enum PexesoGameNavigation {
    case start
}

protocol PexesoGameNavigationHandler: PexesoGameViewController {
    func handle(_ navigation: PexesoGameNavigation)
}

class PexesoGameCoordinator: BaseCoordinator {
    @Injected(\.pexesoComponent.gameViewController) var rootViewController: PexesoGameViewController
    let router: Router
        
    init(router: Router) {
        self.router = router
        super.init()
    }
    
    override func start() {
        rootViewController.coordinator = self
    }
    
    override var viewController: ViewController? {
        rootViewController
    }
    
    func goTo(_ navigation: PexesoGameNavigation, routeBlock: (Drawable, Router) -> Void) {
        let coordinator: Coordinator
        switch navigation {
        case .start:
            coordinator = PexesoStartCoordinator(router: RouterImpl(navigationController: router.navigationController))
        }
        store(coordinator: coordinator)
        coordinator.start()
        routeBlock(coordinator, router)
    }
}
