//
//  StartViewController.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import UIKit
import Combine

class PexesoStartViewController: ViewController {
    private var bindings = Set<AnyCancellable>()
    
    let viewModel: PexesoViewModel
    weak var coordinator: PexesoStartCoordinator!
    
    init?(coder: NSCoder, viewModel: PexesoViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    @IBAction func startAction(_ sender: Button) {
        handle(.game)
    }
    
    // MARK: - Private methods
    
    private func bind(to viewModel: PexesoViewModelOutput) {
        viewModel.level.sink { [weak self] in
            guard let self = self else { return }
            self.selectedLevelLabel.setFormattedText(String($0))
        }.store(in: &bindings)
    }
}

// MARK: - Perform Routing

extension PexesoStartViewController: PexesoStartNavigationHandler {
    func handle(_ navigation: PexesoStartNavigation) {
        coordinator.goTo(navigation) { drawable, router in
            switch navigation {
            case .game:
                router.presentAsStork(drawable, isAnimated: true, onDismiss: nil)
            }
        }
    }
}
