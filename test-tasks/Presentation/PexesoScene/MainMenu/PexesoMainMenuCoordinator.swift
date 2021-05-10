//
//  PexesoStartCoordinator.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 10.03.2021.
//

import Combine

enum PexesoMainMenuNavigation {
    case game
}

protocol PexesoMainMenuNavigationHandler: PexesoMainMenuViewController {
    func handle(_ navigation: PexesoMainMenuNavigation)
}

final class PexesoMainMenuCoordinator: BaseCoordinator {
    
    @Injected(\.pexesoComponent.mainMenuViewController) var rootViewController: PexesoMainMenuViewController
    private(set) var router: Router!
        
    init(router: Router) {
        self.router = router
        super.init()
    }
    
    override init() {
        super.init()
        self.router = RouterImpl(navigationController: NavigationController(rootViewController: self.rootViewController))
    }
    
    override func start() -> AnyPublisher<Void, Never> {
        rootViewController.coordinator = self
        return rootViewController.didDisappear
    }
    
    override var viewController: ViewController? {
        rootViewController
    }
    
    func goTo(_ navigation: PexesoMainMenuNavigation, routeBlock: (Drawable, Router) -> Void) {
        let coordinator: Coordinator
        switch navigation {
        case .game:
            let pexesoGameCoordinator = PexesoGameCoordinator(router: RouterImpl(navigationController: router.navigationController))
            pexesoGameCoordinator.rootViewController.viewModel.setLevel(rootViewController.viewModel.level.value)
            coordinator = pexesoGameCoordinator
        }
        store(coordinator: coordinator)
        
        let coordinatorFinish = coordinator.start().handleEvents(receiveCompletion: { [weak self] _ in
            guard let self = self else { return }
            self.free(coordinator: coordinator)
        })
        coordinatorFinish.sink().store(in: &bindings)
        
        routeBlock(coordinator, router)
    }
}
