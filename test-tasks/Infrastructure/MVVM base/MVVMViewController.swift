//
//  MVVMViewController.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 05.04.2021.
//

import UIKit
import Combine

class MVVMViewController<ViewModel: BaseViewModel, Coordinator: BaseCoordinator>: ViewController {
    
    /// Dispose bag of the View Model
    var bindings = Set<AnyCancellable>()
    
    let viewModel: ViewModel
    weak var coordinator: Coordinator!
    
    init?(coder: NSCoder, viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// - SeeAlso: UIViewController.viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(to: viewModel)
        viewModel.viewDidLoad.send()
    }
    
    /// - SeeAlso: UIViewController.viewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear.send()
    }
    
    /// - SeeAlso: UIViewController.viewDidAppear()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear.send()
    }
    
    /// - SeeAlso: UIViewController.viewWillDisappear()
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear.send()
    }
    
    /// Set here handles for view model updates
    func bind(to viewModel: ViewModel) {
        viewModel.bind.send()
    }
}
