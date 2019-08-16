//
//  CachierLogger.swift
//  KBCachier
//
//  Created by Keshav Bansal on 15/08/19.
//  Copyright © 2019 kb. All rights reserved.
//

import Foundation

// Enum log levels
public enum CachierLoggerLevel: Int {
    case debug = 0, info, warning, error, off
}

class CachierLogger: NSObject {
    
    // Singleton
    static let logger = CachierLogger()
    private override init() {}
    
    // min level
    var minLevel: CachierLoggerLevel = .warning
    
    // logs
    func log(level: CachierLoggerLevel, message: String) {
        guard level.rawValue >= minLevel.rawValue else { return }
        print("KBCashier(\(level)): \(message)")
    }
    
    func debug(_ message: String) {
        log(level: .debug, message: message)
    }
    
    func info(_ message: String) {
        log(level: .info, message: message)
    }
    
    func warning(_ message: String) {
        log(level: .warning, message: message)
    }
    
    func error(_ message: String) {
        log(level: .error, message: message)
    }
    
}

extension CachierLogger {
    
    // Convenience functions
    class func printDebug(_ message: String) {
        CachierLogger.logger.debug(message)
    }
    
    class func printInfo(_ message: String) {
        CachierLogger.logger.info(message)
    }
    
    class func printWarning(_ message: String) {
        CachierLogger.logger.warning(message)
    }
    
    class func printError(_ message: String) {
        CachierLogger.logger.error(message)
    }
    
}
