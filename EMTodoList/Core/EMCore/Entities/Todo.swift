//
//  Todo.swift
//  EMCore
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

import Foundation

public struct Todo {
    public let id: Int64
    
    public var name: String
    public var description: String
    
    public var createdOn: Date
    public var isCompleted: Bool
    
    public init(
        id: Int64,
        name: String,
        description: String,
        createdOn: Date,
        isCompleted: Bool
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.createdOn = createdOn
        self.isCompleted = isCompleted
    }
}
