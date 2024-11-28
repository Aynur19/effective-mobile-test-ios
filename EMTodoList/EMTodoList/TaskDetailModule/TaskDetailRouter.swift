//
//  TaskRouter.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 28.11.2024.
//

import Foundation

protocol TaskDetailRouterProtocol: AnyObject {
    func closeCurrentViewController()
}

class TaskDetailRouter: TaskDetailRouterProtocol {
    weak var viewController: TaskDetailViewController!
    
    required init(viewController: TaskDetailViewController) {
        self.viewController = viewController
    }
 
    func closeCurrentViewController() {
        
    }
}
