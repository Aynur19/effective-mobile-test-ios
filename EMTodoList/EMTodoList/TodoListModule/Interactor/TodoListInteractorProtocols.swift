//
//  TodoListInteractorProtocols.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 30.11.2024.
//

import Foundation

protocol TodoListInteractorProtocol: AnyObject {
    func fetchTodos()
    
    func fetchTodos(searchText: String)
    
    func completeTodo(todoId: Int64)
}
