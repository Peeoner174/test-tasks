//
//  PexesoGameCoordinator.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 10.03.2021.
//

import Combine

enum PexesoGameNavigation {
    case start
}

protocol PexesoGameNavigationHandler: PexesoGameViewController {
    func handle(_ navigation: PexesoGameNavigation)
}

class PexesoGameCoordinator: BaseCoordinator {
    private var bindings = Set<AnyCancellable>()

    @Injected(\.pexesoComponent.gameViewController) var rootViewController: PexesoGameViewController
    let router: Router

    init(router: Router) {
        self.router = router
        super.init()
    }
    
    override func start() -> AnyPublisher<Void, Never> {
        rootViewController.coordinator = self
        return rootViewController.didDisappear
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
        
        let coordinatorFinish = coordinator.start().handleEvents(receiveCompletion: { [weak self] _ in
            guard let self = self else { return }
            self.free(coordinator: coordinator)
        })
        coordinatorFinish.sink().store(in: &bindings)
        
        routeBlock(coordinator, router)
    }
}



