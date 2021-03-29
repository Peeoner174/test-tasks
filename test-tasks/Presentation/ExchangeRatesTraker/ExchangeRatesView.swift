//
//  ExchangeRatesView.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 23.03.2021.
//

import SwiftUI
import Combine

final class ExchangeRatesViewModelWrapper: ObservableObject {
    var viewModel: ExchangeRatesViewModel?
//    @Published var items: [MoviesQueryListItemViewModel] = []

    init(viewModel: ExchangeRatesViewModel?) {
        self.viewModel = viewModel
//        viewModel?.items.observe(on: self) { [weak self] values in self?.items = values }
    }
}

struct ExchangeRatesView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeRatesView()
    }
}


//@available(iOS 13.0, *)
//struct ExchangeRatesView: View {
////    @ObservedObject var viewModel: ExchangeRatesViewModelWrapper
//
//    var body: some View {
//        Text("Target Color Block")
//
//    }
//}
//



