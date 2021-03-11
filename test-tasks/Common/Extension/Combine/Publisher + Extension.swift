//
//  File.swift
//  test-tasks
//
//  Created by MSI on 11.03.2021.
//

import Combine

extension Publisher {
    
    /// Attaches a subscriber with closure-based behavior.
    ///
    /// - Parameters:
    ///   - receiveCompletion: The closure to execute on completion.
    /// - Returns: A cancellable instance; used when you end assignment of the received value. Deallocation of the result will tear down the subscription stream.
    func sink(receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void) -> AnyCancellable
    {
        return sink(receiveCompletion: receiveCompletion, receiveValue: { _ in })
    }
    
    /// Attaches a subscriber with closure-based behavior.
    ///
    /// - Parameters:
    ///   - receiveCompletion: The closure to execute on completion.
    /// - Returns: A cancellable instance; used when you end assignment of the received value. Deallocation of the result will tear down the subscription stream.
    func sink(receiveValue: @escaping (Output) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: { _ in }, receiveValue: receiveValue)
    }
    
    /// Attaches a subscriber with closure-based behavior.
    ///
    /// - Parameters:
    ///   - receiveCompletion: The closure to execute on completion.
    /// - Returns: A cancellable instance; used when you end assignment of the received value. Deallocation of the result will tear down the subscription stream.
    func sink() -> AnyCancellable {
        return sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
}
