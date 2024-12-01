//
//  TodoDetailModuleDelegate.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 01.12.2024.
//

import EMCore

protocol TodoDetailModuleDelegate: AnyObject {
    func didDeleteTodo(_ todo: Todo)
    
    func didSaveTodo(_ todo: Todo)
}
