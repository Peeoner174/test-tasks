//
//  Pexeso.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import NeedleFoundation

protocol PexesoModuleDependency: Dependency {
    var pexesoViewModel: PexesoViewModel { get }
}

class PexesoComponent: Component<PexesoModuleDependency> {
    
    var startViewController: PexesoStartViewController {
        .instantiate(fromStoryboard: .pexeso) { coder in
            PexesoStartViewController(coder: coder, viewModel: self.dependency.pexesoViewModel)
        }
    }
    
    var gameViewController: PexesoGameViewController {
        .instantiate(fromStoryboard: .pexeso) { coder in
            PexesoGameViewController(coder: coder, viewModel: self.dependency.pexesoViewModel)
        }
    }
}

