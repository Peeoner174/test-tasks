//
//  CyrrencyRatesDTO.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 26.03.2021.
//

import Foundation

extension ExchangeRatesApi.LatestResponseDTO {
    func toDomain() -> ConversionRates {
        ConversionRates(timestamp: TimeInterval(self.timestamp), base: self.base, rates: self.rates)
    }
}
