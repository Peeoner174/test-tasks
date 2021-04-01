//
//  ExchangeRatesRepositoryImpl.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 31.03.2021.
//

import Combine
import MoyaNetworkClient_Combine

class ExchangeRatesRepositoryImpl: ExchangeRatesRepository {
    typealias NetworkClient = MoyaNetworkClient_Combine.NetworkClient
    typealias Entity = ConversionRates
    
    var networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchLastUpdates(base: String) -> AnyPublisher<Entity, Error> {
        
        networkClient
            .request(ExchangeRatesApi.latest, class: ExchangeRatesApi.LatestResponseDTO.self)
            .mapError { serverError -> Error in
                serverError
            }
            .map { dtoObject -> Entity in
                dtoObject.toDomain()
            }
            .eraseToAnyPublisher()
    }
}
