//
//  ExchangeRatesViewModel.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 23.03.2021.
//

import Combine

protocol ExchangeRatesViewModelInput {
    
}

protocol ExchangeRatesViewModelOutput {
    
}

protocol ExchangeRatesViewModel: class, ExchangeRatesViewModelInput, ExchangeRatesViewModelOutput {}

final class ExchangeRatesViewModelImpl: ExchangeRatesViewModel {
    
}
