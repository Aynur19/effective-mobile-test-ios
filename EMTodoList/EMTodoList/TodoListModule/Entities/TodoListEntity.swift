//
//  TodoListEntity.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 29.11.2024.
//

import EMCore

class TodoListEntity {
    var todos: [TodoTableCellEntity]
    
    init(todos: [TodoTableCellEntity] = []) {
        self.todos = todos
    }
}

extension TodoListEntity {
    func complete(todoId: Int64) -> TodoTableCellEntity? {
        guard let idx = todos.firstIndex(where: { $0.id == todoId }) else {
            return nil
        }
        
        todos[idx].complete()
        return todos[idx]
    }
}
