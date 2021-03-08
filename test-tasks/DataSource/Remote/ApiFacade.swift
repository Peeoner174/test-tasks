//
//  ApiFacade.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import MoyaNetworkClient_Combine
import Foundation

struct ApiFacade {
    static let networkClient = NetworkClient(jsonDecoder: JSONDecoder())
    
    // TODO
    static let baseURL = URL(string: "")!
    static let mockURL = URL(string: "")!
}
