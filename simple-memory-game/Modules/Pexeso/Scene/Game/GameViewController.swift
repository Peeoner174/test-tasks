//
//  ViewController.swift
//  simple-memory-game
//
//  Created by MSI on 19.01.2021.
//

import UIKit
import Combine

class GameViewController: ViewController {
    private var bindings = Set<AnyCancellable>()
    
    weak var viewModel: PexesoViewModel!
    weak var coordinator: PexesoCoordinator!
    
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

extension GameViewController: CardsHolderViewDelegate {
    func restartButtonTapped() {
        viewModel.getCards()
    }
}

// MARK: - Perform Routing

extension GameViewController: PexesoNavigationHandler {
    func handle(_ navigation: PexesoNavigation) {
        coordinator.getViewControllerAndRoute(navigation) { drawable, router in
            switch navigation {
            case .game:
                break
            case .start:
                router.dismiss(animated: true, completion: nil)
            }
        }
    }
}
