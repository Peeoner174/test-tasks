//
//  CyrrencyRatesDTO.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 26.03.2021.
//

import Foundation

extension ExchangeRatesApi.LatestResponseDTO {
    typealias ConversionRates = Сurrency.ConversionRates
    
    func toDomain() -> ConversionRates {
        
        let rates = self.rates.keys.sorted().map {
            ConversionRates.Rate(id: $0, value: self.rates[$0] ?? 0.0)
        }
        
        return ConversionRates(timestamp: TimeInterval(self.timestamp), base: self.base, rates: rates)
    }
}
