//
//  StartViewController.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import UIKit
import Combine

class PexesoMainMenuViewController: MVVMViewController<AnyPexesoMainMenuViewModel, PexesoMainMenuCoordinator> {
    
    // MARK: - UI Properties
    
    @IBOutlet weak var selectedLevelLabel: Label!
    @IBOutlet weak var selectLevelSlider: UISlider!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectLevelSlider.minimumValue = Float(self.viewModel.levelRange.first!)
        selectLevelSlider.maximumValue = Float(self.viewModel.levelRange.last!)
    }
    
    override func bind(to viewModel: AnyPexesoMainMenuViewModel) {
        super.bind(to: viewModel)
        
        viewModel.level.sink { [weak self] in
            guard let self = self else { return }
            self.selectedLevelLabel.setFormattedText(String($0))
        }.store(in: &bindings)
    }
    
    // MARK: Actions
    
    @IBAction func selectLevelAction(_ sender: UISlider) {
        let step: Float = 1
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        
        viewModel.updateLevel(Int(sender.value))
    }
    
    @IBAction func startAction(_ sender: Button) {
        handle(.game)
    }
}

// MARK: - Perform Routing

extension PexesoMainMenuViewController: PexesoMainMenuNavigationHandler {
    func handle(_ navigation: PexesoMainMenuNavigation) {
        coordinator.goTo(navigation) { drawable, router in
            switch navigation {
            case .game:
                router.presentAsStork(drawable, isAnimated: true, onDismiss: nil)
            }
        }
    }
}
