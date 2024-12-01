//
//  TaskEntity.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 28.11.2024.
//

import Foundation
import EMCore

struct TodoDetailEntity {
    let id: Int64
    
    var name: String
    var description: String
    
    var createdOn: Date
    var isCompleted: Bool
}


extension TodoDetailEntity {
    static func getNewEmpty() -> Self {
        let createdOn = Date.now
        
        return .init(
            id: createdOn.msTimestamp,
            name: "",
            description: "",
            createdOn: createdOn,
            isCompleted: false
        )
    }
    
    static func create(todo: Todo) -> Self {
        .init(
            id: todo.id,
            name: todo.name,
            description: todo.description,
            createdOn: todo.createdOn,
            isCompleted: todo.isCompleted
        )
    }
}
