//
//  Date.Extensions.swift
//  EMCore
//
//  Created by Aynur Nasybullin on 28.11.2024.
//

import Foundation

extension Date {
    public var todoShortDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        return dateFormatter.string(from: self)
    }
    
    public var msTimestamp: Int64 {
        Int64(timeIntervalSince1970 * 1000)
    }
}
