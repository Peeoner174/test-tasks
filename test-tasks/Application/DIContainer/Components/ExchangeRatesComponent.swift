//
//  ExchangeRatesComponent.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 05.04.2021.
//

import NeedleFoundation

protocol ExchangeRatesDependency: Dependency {
    var exchangeRatesViewModel: ExchangeRatesViewModel { get }
}

class ExchangeRatesComponent: Component<ExchangeRatesDependency> {
    
    var exchangeRatesContentView: ExchangeRatesContentView {
        ExchangeRatesContentView(viewModel: dependency.exchangeRatesViewModel)
    }
}

