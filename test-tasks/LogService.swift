//
//  LogService.swift
//  test-tasks
//
//  Created by MSI on 07.02.2021.
//

import SwiftyBeaver

struct LogMessage {
    let message: Any
    let file: String
    let function: String
    let line: Int
    let context: Any?
    
    init(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line,
        context: Any? = nil
    ) {
        self.file = file
        self.function = function
        self.line = line
        self.message = message()
        self.context = context
    }
}

protocol LogService: Service {
    
    /// log something generally unimportant (lowest priority)
    func verbose(_ logMessage: LogMessage)
    
    /// log something which help during debugging (low priority)
    func debug(_ logMessage: LogMessage)
    
    /// log something which you are really interested but which is not an issue or error (normal priority)
    func info(_ logMessage: LogMessage)
    
    /// log something which may cause big trouble soon (high priority)
    func warning(_ logMessage: LogMessage)
    
    /// log something which will keep you awake at night (highest priority)
    func error(_ logMessage: LogMessage)
}


class Service {
    func start() {
        fatalError("Children should implement `start`.")
    }
}

class LogServiceSwiftyBeaver: Service, LogService {
    typealias logger = SwiftyBeaver
    
    override func start() {
        let console = ConsoleDestination()
        let file = FileDestination()
        let cloud = SBPlatformDestination(
            appID: "1P9mNQ",
            appSecret: "ziy3nmo8jbtPxba2edfix7hlnez1kcbn",
            encryptionKey: "0vsvr8jqzph7ezqniiyyb8Ivhv16gbvl"
        )
        
        console.minLevel = .verbose
        file.minLevel = .warning
        cloud.minLevel = .verbose
        
        logger.addDestination(console)
        logger.addDestination(file)
        logger.addDestination(cloud)
    }
    
    func verbose(_ logMessage: LogMessage) {
        logger.custom(
            level: .verbose,
            message: logMessage.message,
            file: logMessage.file,
            function: logMessage.function,
            line: logMessage.line,
            context: logMessage.context
        )
    }
    
    func debug(_ logMessage: LogMessage) {
        logger.custom(
            level: .debug,
            message: logMessage.message,
            file: logMessage.file,
            function: logMessage.function,
            line: logMessage.line,
            context: logMessage.context
        )
    }
    
    func info(_ logMessage: LogMessage) {
        logger.custom(
            level: .info,
            message: logMessage.message,
            file: logMessage.file,
            function: logMessage.function,
            line: logMessage.line,
            context: logMessage.context
        )
    }
    
    func warning(_ logMessage: LogMessage) {
        logger.custom(
            level: .warning,
            message: logMessage.message,
            file: logMessage.file,
            function: logMessage.function,
            line: logMessage.line,
            context: logMessage.context
        )
    }
    
    func error(_ logMessage: LogMessage) {
        logger.custom(
            level: .error,
            message: logMessage.message,
            file: logMessage.file,
            function: logMessage.function,
            line: logMessage.line,
            context: logMessage.context
        )
    }
}


