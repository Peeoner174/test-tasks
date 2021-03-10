//
//  PexesoStartCoordinator.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 10.03.2021.
//

enum PexesoStartNavigation {
    case game
}

protocol PexesoStartNavigationHandler: PexesoStartViewController {
    func handle(_ navigation: PexesoStartNavigation)
}

class PexesoStartCoordinator: BaseCoordinator {
    @Injected(\.pexesoComponent.startViewController) var rootViewController: PexesoStartViewController
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
    
    func goTo(_ navigation: PexesoStartNavigation, routeBlock: (Drawable, Router) -> Void) {
        let coordinator: Coordinator
        switch navigation {
        case .game:
            coordinator = PexesoGameCoordinator(router: RouterImpl(navigationController: router.navigationController))
        }
        store(coordinator: coordinator)
        coordinator.start()
        routeBlock(coordinator, router)
    }
}
