//
//  PexesoStartCoordinator.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 10.03.2021.
//

import Combine

enum PexesoStartNavigation {
    case game
}

protocol PexesoStartNavigationHandler: PexesoStartViewController {
    func handle(_ navigation: PexesoStartNavigation)
}

class PexesoStartCoordinator: BaseCoordinator {
    private var bindings = Set<AnyCancellable>()

    @Injected(\.pexesoComponent.startViewController) var rootViewController: PexesoStartViewController
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
    
    func goTo(_ navigation: PexesoStartNavigation, routeBlock: (Drawable, Router) -> Void) {
        let coordinator: Coordinator
        switch navigation {
        case .game:
            coordinator = PexesoGameCoordinator(router: RouterImpl(navigationController: router.navigationController))
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
