//
//  ExchangeRatesApi.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 26.03.2021.
//

import MoyaNetworkClient_Combine
import Foundation

enum ExchangeRatesApi {
    case latest(currencyBase: String)
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
