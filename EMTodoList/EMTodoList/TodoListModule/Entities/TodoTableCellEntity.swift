//
//  TodoTableCellEntity.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 30.11.2024.
//

import Foundation
import EMCore

struct TodoTableCellEntity {
    let id: Int64
    
    var name: String
    var description: String
    
    var createdOn: Date
    var createdOnStr: String
    var isCompleted: Bool
}
 

extension TodoTableCellEntity {
    static func create(todo: Todo) -> Self {
        .init(
            id: todo.id,
            name: todo.name,
            description: todo.description,
            createdOn: todo.createdOn,
            createdOnStr: todo.createdOn.todoShortDate,
            isCompleted: todo.isCompleted
        )
    }
    
    var todo: Todo {
        .init(
            id: id,
            name: name,
            description: description,
            createdOn: createdOn,
            isCompleted: isCompleted
        )
    }
    
    mutating func complete() {
        isCompleted.toggle()
    }
}
