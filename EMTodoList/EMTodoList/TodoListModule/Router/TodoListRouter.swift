//
//  TodoListRouter.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 29.11.2024.
//

import UIKit

class TodoListRouter {
    weak var viewController: TodoListViewController!
    
    required init(viewController: TodoListViewController) {
        self.viewController = viewController
    }
}


extension TodoListRouter: TodoListRouterProtocol {
    func navigateToTodoDetail(for todoId: Int64?) {
        let todoDetailViewController = TodoDetailConfigurator.createModule(for: todoId)
        viewController.navigationController?.pushViewController(
            todoDetailViewController, animated: true
        )
    }
}
