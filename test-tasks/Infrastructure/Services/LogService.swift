//
//  LogService.swift
//  test-tasks
//
//  Created by MSI on 07.02.2021.
//

import SwiftyBeaver

let logger = LogService.shared

class LogService: Service {
    typealias logger = SwiftyBeaver
    
    private override init() {
        super.init()
    }

    static let shared = LogService()
    
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
    
    func verbose(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line,
        context: Any? = nil
    ) {
        logger.custom(
            level: .verbose,
            message: message(),
            file: file,
            function: function,
            line: line,
            context: context
        )
    }
    
    func debug(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line,
        context: Any? = nil
    ) {
        logger.custom(
            level: .debug,
            message: message(),
            file: file,
            function: function,
            line: line,
            context: context
        )
    }
    
    func info(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line,
        context: Any? = nil
    ) {
        logger.custom(
            level: .info,
            message: message(),
            file: file,
            function: function,
            line: line,
            context: context
        )
    }
    
    func warning(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line,
        context: Any? = nil
    ) {
        logger.custom(
            level: .warning,
            message: message(),
            file: file,
            function: function,
            line: line,
            context: context
        )
    }
    
    func error(
        _ message: @autoclosure () -> Any,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line,
        context: Any? = nil
    ) {
        logger.custom(
            level: .error,
            message: message(),
            file: file,
            function: function,
            line: line,
            context: context
        )
    }
}


