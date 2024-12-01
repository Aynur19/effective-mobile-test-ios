//
//  TodoDetailPresenter.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 28.11.2024.
//

import Foundation

class TodoDetailPresenter {
    weak var view: TodoDetailViewPresenterProtocol?
    weak var delegate: TodoDetailModuleDelegate?
    
    var interactor: TodoDetailInteractorProtocol!
    var router: TodoDetailRouterProtocol!
    
    required init(
        view: TodoDetailViewPresenterProtocol,
        delegate: TodoDetailModuleDelegate
    ) {
        self.view = view
        self.delegate = delegate
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
    
    func viewWillDisappear(todo: TodoDetailEntity) {
        interactor.saveTodo(todo)
    }
}

extension TodoDetailPresenter: TodoDetailPresenterInteractorProtocol {
    func didFetch(todo: TodoDetailEntity?) {
        view?.show(todo: todo)
    }
    
    func didDelete(todo: TodoDetailEntity) {
        delegate?.didDeleteTodo(todo.todo)
    }
    
    func didSave(todo: TodoDetailEntity) {
        delegate?.didSaveTodo(todo.todo)
    }
}
