//
//  TodoDetailConfiguratorProtocols.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 01.12.2024.
//

import Foundation

protocol TodoDetailConfiguratorProtocol: AnyObject {
    static func createModule(for todoId: Int64?, delegate: TodoDetailModuleDelegate) -> TodoDetailViewController
}
