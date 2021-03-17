//
//  ViewController.swift
//  test-tasks
//
//  Created by MSI on 19.01.2021.
//

import UIKit
import Combine

class PexesoGameViewController: ViewController {
    private var bindings = Set<AnyCancellable>()
    
    let viewModel: PexesoViewModel
    weak var coordinator: PexesoGameCoordinator!
    
    init?(coder: NSCoder, viewModel: PexesoViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - UI Properties
    
    @IBOutlet weak var cardsHolderView: CardsHolderView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getCards()
        bind(to: viewModel)
    }
    
    // MARK: - Private methods

    private func bind(to viewModel: PexesoViewModelOutput) {
        self.cardsHolderView.configure(with: viewModel.cards, delegate: self)
    }
}

// MARK: - CardsHolderViewDelegate

extension PexesoGameViewController: CardsHolderViewDelegate {
    func restartButtonTapped() {
        viewModel.getCards()
        
        
        
        
        
        
            
    }
}

// MARK: - Perform Routing

extension PexesoGameViewController: PexesoGameNavigationHandler {
    func handle(_ navigation: PexesoGameNavigation) {
        coordinator.goTo(navigation) { drawable, router in
            switch navigation {
            case .start:
                router.dismiss(animated: true, completion: nil)
            }
        }
    }
}
