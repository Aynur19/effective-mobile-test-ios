//
//  Todo.Extensions.swift
//  EMTodoApiService
//
//  Created by Aynur Nasybullin on 29.11.2024.
//

import EMCore
import EMNetworkingService

extension Todo {
    static func create(todoList: TodoListResponseDto) -> [Self] {
        todoList.todos.map { .create(todo: $0) }
    }
    
    static func create(todo: TodoResponseDto) -> Self {
        .init(
            id: todo.id,
            name: String(todo.id),
            description: todo.todo,
            createdOn: .now,
            isCompleted: todo.completed
        )
    }
}
