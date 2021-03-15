//
//  CompletionBlocks.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

/// Closure with custom arguments and return value.
typealias Closure<Input, Output> = (Input) -> Output

/// Closure with no arguments and custom return value.
typealias ResultClosure<Output> = () -> Output

/// Closure that takes custom arguments and returns Void.
typealias ParameterClosure<Input> = Closure<Input, Void>

// MARK: Throwable versions
/// Closure with custom arguments and return value, may throw an error.
typealias ThrowableClosure<Input, Output> = (Input) throws -> Output

/// Closure with no arguments and custom return value, may throw an error.
typealias ThrowableResultClosure<Output> = () throws -> Output

/// Closure that takes custom arguments and returns Void, may throw an error.
typealias ThrowableParameterClosure<Input> = ThrowableClosure<Input, Void>

// MARK: Concrete closures
/// Closure that takes no arguments and returns Void.
typealias VoidClosure = ResultClosure<Void>

/// Closure that takes no arguments, may throw an error and returns Void.
typealias ThrowableVoidClosure = () throws -> Void
