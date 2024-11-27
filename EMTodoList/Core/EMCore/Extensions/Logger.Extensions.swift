//
//  Logger.Extensions.swift
//  EMCore
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

import OSLog

extension Logger {
    public func debug(message: String) {
        self.debug("\(message)")
    }
    
    public func info(message: String) {
        self.info("\(message)")
    }
    
    public func error(message: String) {
        self.error("\(message)")
    }
    
    public func warning(message: String) {
        self.warning("\(message)")
    }
}

