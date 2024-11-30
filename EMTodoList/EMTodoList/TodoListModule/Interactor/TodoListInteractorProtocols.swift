//
//  TodoListInteractorProtocols.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 30.11.2024.
//

protocol TodoListInteractorProtocol: AnyObject {
    func fetchTodos()
    
    func completeTodo(todoId: Int64)
}
