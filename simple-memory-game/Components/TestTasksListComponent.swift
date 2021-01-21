//
//  TestTasksListComponent.swift
//  simple-memory-game
//
//  Created by MSI on 20.01.2021.
//

import NeedleFoundation

protocol TestTaskListDependency: Dependency {
    var testTaskListCoordinator: TestTasksListCoordinator { get }
}

class TestTaskListComponent: Component<TestTaskListDependency> {
    
    var mainViewController: TestTasksListViewController {
        let vc = TestTasksListViewController.instantiate(fromStoryboard: .testTasksList)
        vc.coordinator = dependency.testTaskListCoordinator
        return vc
    }
}
