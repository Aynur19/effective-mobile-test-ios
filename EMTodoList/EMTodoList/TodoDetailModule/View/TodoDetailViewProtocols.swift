//
//  TodoDetailViewProtocols.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 01.12.2024.
//

protocol TodoDetailViewConfiguratorProtocol: AnyObject {
    func configure(todoId: Int64?, presenter: TodoDetailPresenterViewProtocol)
}

protocol TodoDetailViewPresenterProtocol: AnyObject {
    func show(todo: TodoDetailEntity?)
}
