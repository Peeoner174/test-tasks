//
//  Сurrency.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 31.03.2021.
//

import Foundation

struct ConversionRates: Equatable {
    let timestamp: TimeInterval
    let base: String
    let rates: [String: Double]
}

struct Сurrency: Equatable {
    let name: String
    let conversionRates: ConversionRates
}
