//
//  StartViewController.swift
//  simple-memory-game
//
//  Created by MSI on 20.01.2021.
//

import UIKit
import Combine

class StartViewController: ViewController {
    private var bindings = Set<AnyCancellable>()
    
    weak var viewModel: PexesoViewModel!
    weak var coordinator: PexesoCoordinator!
    
    // MARK: - UI Properties
    
    @IBOutlet weak var selectedLevelLabel: Label!
    @IBOutlet weak var selectLevelSlider: UISlider!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectLevelSlider.minimumValue = Float(self.viewModel.levelRange.first!)
        selectLevelSlider.maximumValue = Float(self.viewModel.levelRange.last!)
        bind(to: viewModel)
    }
    
    // MARK: Actions
    
    @IBAction func selectLevelAction(_ sender: UISlider) {
        let step: Float = 1
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        
        viewModel.updateLevel(Int(sender.value))
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        handle(.game)
    }
    
    // MARK: - Private methods
    
    private func bind(to viewModel: PexesoViewModelOutput) {
        viewModel.level.assertNoFailure().sink { [weak self] in
            guard let self = self else { return }
            self.selectedLevelLabel.setFormattedText(String($0))
        }.store(in: &bindings)
    }
}

// MARK: - Perform Routing

extension StartViewController: PexesoNavigationHandler {
    func handle(_ navigation: PexesoNavigation) {
        coordinator.getViewControllerAndRoute(navigation) { drawable, router in
            switch navigation {
            case .game:
                router.presentAsStork(drawable, isAnimated: true, onDismiss: nil)
            case .start:
                break
            }
        }
    }
}
