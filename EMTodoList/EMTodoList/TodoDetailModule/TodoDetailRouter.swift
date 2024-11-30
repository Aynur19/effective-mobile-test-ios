//
//  TodoDetailRouter.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 28.11.2024.
//

import Foundation

protocol TodoDetailRouterProtocol: AnyObject {
    func closeCurrentViewController()
}

class TodoDetailRouter: TodoDetailRouterProtocol {
    weak var viewController: TodoDetailViewController!
    
    required init(viewController: TodoDetailViewController) {
        self.viewController = viewController
    }
 
    func closeCurrentViewController() {
        
    }
}
