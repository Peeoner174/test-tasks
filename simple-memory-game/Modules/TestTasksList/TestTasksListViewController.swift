//
//  TestTasksListViewController.swift
//  simple-memory-game
//
//  Created by MSI on 20.01.2021.
//

import UIKit

class TestTasksListViewController: ViewController {
    weak var coordinator: TestTasksListCoordinator!
}

extension TestTasksListViewController: TestTasksListNavigationHandler {
    func handle(_ navigation: TestTasksListNavigation) {
        coordinator.getViewControllerAndRoute(navigation) { drawable, router in
            switch navigation {
            case .main:
                break
            case .pexeso:
                router.presentAsRoot(drawable, isAnimated: false, setNavigationBarHidden: true)
            }
        }
    }
}
