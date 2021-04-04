//
//  Сurrency.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 31.03.2021.
//

import Foundation

struct Сurrency: Equatable {
    let name: String
    let conversionRates: ConversionRates
    
    struct ConversionRates: Equatable {
        let timestamp: TimeInterval
        let base: String
        let rates: [Rate]
        
        struct Rate: Identifiable, Equatable {
            var id: String
            var value: Double
        }
    }
}

