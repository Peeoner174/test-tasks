//
//  CompletionBlocks.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

public typealias EmptyBlock = (() -> Void)?

public typealias ResultCompletion<T> = ((Swift.Result<T, Error>) -> Void)

public typealias Result<Success> = Swift.Result<Success, Error>
