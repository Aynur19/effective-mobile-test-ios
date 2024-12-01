//
//  TodoDetailInteractorProtocols.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 01.12.2024.
//

protocol TodoDetailInteractorProtocol: AnyObject {
    func fetchTodo(by id: Int64)
    
    func saveTodo(_ todo: TodoDetailEntity)
}
