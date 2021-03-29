//
//  CyrrencyRatesDTO.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 26.03.2021.
//

struct CyrrencyRatesResponseDTO: Decodable {
    let disclaimer: String
    let license: String
    let base: String
    let timestamp: Int
    let rates: [String: Double]
}

extension CyrrencyRatesResponseDTO {
//    func toDomain() ->
}
