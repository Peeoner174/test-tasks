//
//  Pexeso.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import NeedleFoundation

protocol PexesoModuleDependency: Dependency {
    var pexesoViewModel: PexesoViewModel { get }
    var pexesoCoordinator: PexesoCoordinator { get }
}

class PexesoComponent: Component<PexesoModuleDependency> {
    
    var startViewController: StartViewController {
        let vc = StartViewController.instantiate(fromStoryboard: .pexeso)
        vc.viewModel = dependency.pexesoViewModel
        vc.coordinator = dependency.pexesoCoordinator
        return vc
    }
    
    var gameViewController: GameViewController {
        let vc = GameViewController.instantiate(fromStoryboard: .pexeso)
        vc.viewModel = dependency.pexesoViewModel
        vc.coordinator = dependency.pexesoCoordinator
        return vc
    }
}

