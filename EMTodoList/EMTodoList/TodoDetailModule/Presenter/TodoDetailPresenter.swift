//
//  TodoDetailPresenter.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 28.11.2024.
//

import Foundation

class TodoDetailPresenter {
    weak var view: TodoDetailViewPresenterProtocol?
    var interactor: TodoDetailInteractorProtocol!
    var router: TodoDetailRouterProtocol!
    
    required init(view: TodoDetailViewPresenterProtocol) {
        self.view = view
    }
}

extension TodoDetailPresenter: TodoDetailPresenterConfiguratorProtocol {
    func configure(interactor: TodoDetailInteractorProtocol, router: TodoDetailRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension TodoDetailPresenter: TodoDetailPresenterViewProtocol {
    func viewDidLoad(for todoId: Int64) {
        interactor.fetchTodo(by: todoId)
    }
}

extension TodoDetailPresenter: TodoDetailPresenterInteractorProtocol {
    func didFetch(todo: TodoDetailEntity?) {
        view?.show(todo: todo)
    }
}
