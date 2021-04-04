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

    init(viewModel: ExchangeRatesViewModel!) {
        self.value = viewModel
    }
}

struct ExchangeRatesContentView: View {
    @ObservedObject var viewModelWrapper: ExchangeRatesViewModelWrapper
    private var viewModel: ExchangeRatesViewModel { viewModelWrapper.value }
    
    init(viewModel: ExchangeRatesViewModel) {
        self.viewModelWrapper = ExchangeRatesViewModelWrapper(viewModel: viewModel)
    }
    
    var body: some View {
        CurrencyRatesListView(rates: [])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeRatesContentView(viewModel: ExchangeRatesViewModelImpl() )
    }
}
