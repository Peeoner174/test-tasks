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
        
        bind(to: viewModel)
        viewModel.getCards()
    }
    
    // MARK: - Private methods

    private func bind(to viewModel: PexesoViewModelOutput) {
        viewModel.fetchCardsUseCase.state.removeDuplicates().sink(on: .main) { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading:
                print("Loading")
            case .object(let cards):
                print("\(cards.count) objects loaded")
                self.cardsHolderView.dataModelUpdate(cards)
            case .complete:
                print("complete")
            default:
                break
            }
        }
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
