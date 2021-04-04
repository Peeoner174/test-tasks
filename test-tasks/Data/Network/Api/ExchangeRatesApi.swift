//
//  ExchangeRatesApi.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 26.03.2021.
//

import MoyaNetworkClient_Combine
import Foundation

enum ExchangeRatesApi {
    case latest
    
    struct LatestResponseDTO: Decodable {
        let disclaimer: String
        let license: String
        let base: String
        let timestamp: Int
        let rates: [String: Double]
    }
}

extension ExchangeRatesApi: NetworkTarget {
    var baseURL: URL {
        AppConfiguration.currencyExchangeBaseURL
    }
    
    var route: Route {
        .get("/api/latest.json")
    }
    
    var task: Task {
        .requestParameters(
            requestBody: (
                parameters: ["app_id" : AppConfiguration.app_id],
                encodingType: .json
            ),
            urlParameters: nil
        )
    }
    
    var headers: [String : String]? {
        nil
    }
}

extension ExchangeRatesApi: ServerStubable {
    var mockBaseUrl: URL {
        AppConfiguration.currencyExchangeMockURL
    }
}



