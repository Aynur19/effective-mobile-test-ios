//
//  TodoDetailPresenterProtocols.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 01.12.2024.
//

protocol TodoDetailPresenterConfiguratorProtocol: AnyObject {
    func configure(interactor: TodoDetailInteractorProtocol, router: TodoDetailRouterProtocol)
}

protocol TodoDetailPresenterViewProtocol: AnyObject {
    func viewDidLoad(for todoId: Int64)
}

protocol TodoDetailPresenterInteractorProtocol: AnyObject {
    func didFetch(todo: TodoDetailEntity?)
}
