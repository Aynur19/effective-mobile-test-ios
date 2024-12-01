//
//  TodoListRouterProtocols.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 30.11.2024.
//

import EMCore

protocol TodoListRouterProtocol: AnyObject {
    func navigateToTodoDetail(for todoId: Int64?)
}
