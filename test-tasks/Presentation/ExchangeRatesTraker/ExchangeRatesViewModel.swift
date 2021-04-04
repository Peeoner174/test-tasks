//
//  ExchangeRatesViewModel.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 23.03.2021.
//

import Combine
import UseCaseKit

protocol ExchangeRatesViewModelInput {
    
}

protocol ExchangeRatesViewModelOutput {
    var exchangeRatesUseCase: UseCase<FetchExchangeRatesCommand> { get }
}

protocol ExchangeRatesViewModel: class, ExchangeRatesViewModelInput, ExchangeRatesViewModelOutput {}

final class ExchangeRatesViewModelImpl: ExchangeRatesViewModel {
    var exchangeRatesUseCase: UseCase<FetchExchangeRatesCommand> = .fetchLastDefault()
    
    func t() {
        exchangeRatesUseCase.dispatcher.dispatch(.fetchLast(base: ""))
    }
    
}
