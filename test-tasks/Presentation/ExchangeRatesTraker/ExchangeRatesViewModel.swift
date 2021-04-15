//
//  ExchangeRatesViewModel.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 23.03.2021.
//

import Combine
import UseCase_Combine

protocol ExchangeRatesViewModel: BaseViewModel {
    var exchangeRatesUseCase: UseCase<FetchExchangeRatesCommand> { get }
}

final class ExchangeRatesViewModelImpl: BaseViewModel, ExchangeRatesViewModel {
    var exchangeRatesUseCase: UseCase<FetchExchangeRatesCommand> = .fetchLastMock()

    override init() {
        super.init()
        
        viewWillAppear.sink(receiveValue: {
            self.exchangeRatesUseCase.dispatcher.dispatch(.fetchLast(base: ""))
        }).store(in: &bindings)
    }
}



