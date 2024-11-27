//
//  EMTask.swift
//  EMCore
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

import Foundation

public struct EMTask {
    public let id: Int64
    
    public var name: String
    public var taskDescription: String
    
    public var createdOn: Date?
    public var isCompleted: Bool
    
    public init(
        id: Int64,
        name: String,
        taskDescription: String,
        createdOn: Date? = nil,
        isCompleted: Bool
    ) {
        self.id = id
        self.name = name
        self.taskDescription = taskDescription
        self.createdOn = createdOn
        self.isCompleted = isCompleted
    }
}
