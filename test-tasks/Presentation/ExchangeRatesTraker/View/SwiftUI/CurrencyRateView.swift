//
//  СurrencyRateRow.swift
//  test-tasks
//
//  Created by MSI on 04.04.2021.
//

import SwiftUI

struct CurrencyRateRowView: View {
    var name: String
    var rate: Double
    
    var body: some View {
        HStack {
            Text("\(name): \(rate)")
            Spacer()
        }
    }
}

struct CurrencyRateRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CurrencyRateRowView(name: "RUB", rate: 88.5)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
