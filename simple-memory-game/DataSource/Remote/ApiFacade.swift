//
//  ApiFacade.swift
//  simple-memory-game
//
//  Created by MSI on 20.01.2021.
//

import MoyaNetworkClient_Combine

struct ApiFacade {
    static let networkClient = NetworkClient(jsonDecoder: JSONDecoder())
    
    // TODO
    static let baseURL = URL(string: "")!
    static let mockURL = URL(string: "")!
}