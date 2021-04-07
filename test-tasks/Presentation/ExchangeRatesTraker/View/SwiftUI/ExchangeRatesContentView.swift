//
//  ExchangeRatesView.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 23.03.2021.
//

import SwiftUI
import Combine

final class ExchangeRatesViewModelWrapper: ObservableObject {
    var value: ExchangeRatesViewModel!
    
    /// Page content
    @Published var items: [Сurrency.ConversionRates.Rate] = []
    /// Indicates if there is ongoing loading of page content
    @State var isLoading: Bool = false
    
    init(viewModel: ExchangeRatesViewModel!) {
        self.value = viewModel
        self.bind(to: viewModel)
    }
    
    private func bind(to viewModel: ExchangeRatesViewModel) {
        viewModel.exchangeRatesUseCase.state.removeDuplicates().sink { [weak self] in
            guard let self = self else { return }
            switch $0 {
            case .object(let actualRates):
                self.items = actualRates.rates
            case .loading:
                self.isLoading = true
            case .complete:
                self.isLoading = false
            default:
                break
            }
        }
    }
}
final class ExchangeRatesCoordinator: BaseCoordinator {
    
}

final class ExchangeRatesCoordinatorWrapper: ObservableObject {
    var value: ExchangeRatesCoordinator!
    
    init() {}
    
    init(coordinator: ExchangeRatesCoordinator) {
        self.value = coordinator
    }
}

struct ExchangeRatesContentView: View {
    @ObservedObject var viewModelWrapper: ExchangeRatesViewModelWrapper
    @ObservedObject var coordinatorWrapper = ExchangeRatesCoordinatorWrapper()
    
    private var viewModel: ExchangeRatesViewModel { viewModelWrapper.value }
    
    init(viewModel: ExchangeRatesViewModel) {
        self.viewModelWrapper = ExchangeRatesViewModelWrapper(viewModel: viewModel)
        viewModel.exchangeRatesUseCase.dispatcher.dispatch(.fetchLast(base: ""))
    }
    
    var body: some View {
        if self.viewModelWrapper.isLoading {
            Text("Content is loading")
        } else {
            CurrencyRatesListView(rates: viewModelWrapper.items)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeRatesContentView(viewModel: ExchangeRatesViewModelImpl() )
    }
}
