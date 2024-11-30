//
//  TodoTableCellEntity.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 30.11.2024.
//

import EMCore

struct TodoTableCellEntity {
    let id: Int64
    
    var name: String
    var description: String
    
    var createdOn: String
    var isCompleted: Bool
}
 

extension TodoTableCellEntity {
    static func create(todo: Todo) -> Self {
        .init(
            id: todo.id,
            name: todo.name,
            description: todo.description,
            createdOn: todo.createdOn.todoShortDate,
            isCompleted: todo.isCompleted
        )
    }
    
    mutating func complete() {
        isCompleted.toggle()
    }
}
