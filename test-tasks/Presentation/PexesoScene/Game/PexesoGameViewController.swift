//
//  ViewController.swift
//  test-tasks
//
//  Created by MSI on 19.01.2021.
//

import UIKit
import Combine

class PexesoGameViewController: MVVMViewController<AnyPexesoViewModel, PexesoGameCoordinator> {
        
    // MARK: - UI Properties
    
    @IBOutlet weak var cardsHolderView: CardsHolderView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsHolderView.configure(delegate: self)
    }
    
    override func bind(to viewModel: AnyPexesoViewModel) {
        super.bind(to: viewModel)
        
        // USECASE-COMBINE
        viewModel.fetchCardsUseCase.state.removeDuplicates().receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    break
                case .object(let cards):
                    self.cardsHolderView.dataModelUpdate(cards)
                case .complete:
                    break
                default:
                    break
                }
            }.store(in: &bindings)
    }
}

// MARK: - CardsHolderViewDelegate

extension PexesoGameViewController: CardsHolderViewDelegate {
    func restartButtonTapped() {
        viewModel.fetchCardsUseCase.dispatcher.dispatch(.fetchRandomCardsPairs(numberOfPairs: viewModel.level.value))
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
