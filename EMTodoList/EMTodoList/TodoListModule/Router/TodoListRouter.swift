//
//  TodoListRouter.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 29.11.2024.
//

class TodoListRouter {
    weak var viewController: TodoListViewController!
    
    required init(viewController: TodoListViewController) {
        self.viewController = viewController
    }
}


extension TodoListRouter: TodoListRouterProtocol {
    
}
