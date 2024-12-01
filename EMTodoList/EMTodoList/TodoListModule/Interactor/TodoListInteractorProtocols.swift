//
//  TodoListInteractorProtocols.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 30.11.2024.
//

import Foundation
import EMCore

protocol TodoListInteractorProtocol: AnyObject {
    func fetchTodos()
    
    func fetchTodos(searchText: String)
    
    func fetchTodo(for id: Int64)
    
    func completeTodo(for id: Int64)
    
    func deleteTodo(for id: Int64)
}
