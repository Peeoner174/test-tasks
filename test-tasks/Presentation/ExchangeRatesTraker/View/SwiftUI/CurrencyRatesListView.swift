//
//  СurrencyRatesList.swift
//  test-tasks
//
//  Created by MSI on 04.04.2021.
//

import SwiftUI

struct CurrencyRatesListView: View {
    var rates: [Сurrency.ConversionRates.Rate]
    
    var body: some View {
        List(rates) { rate in
            CurrencyRateRowView(name: rate.id, rate: rate.value)
        }
    }
}

struct CurrencyRatesList_Previews: PreviewProvider {
    typealias Rate = Сurrency.ConversionRates.Rate
    
    static var previews: some View {
        CurrencyRatesListView(rates: [
            Rate(id: "RUS", value: 88.5),
            Rate(id: "RUS", value: 88.5),
            Rate(id: "RUS", value: 88.5)
        ])
    }
}
