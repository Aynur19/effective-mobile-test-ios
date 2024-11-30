//
//  TodoListPresenter.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 29.11.2024.
//

import Foundation
import EMCore

class TodoListPresenter {
    weak var view: TodoListViewProtocol?
    var interactor: TodoListInteractorProtocol!
    var router: TodoListRouterProtocol!
    
    required init(view: TodoListViewProtocol) {
        self.view = view
    }
}

extension TodoListPresenter: TodoListPresenterViewProtocol {
    func viewDidLoad() {
        interactor.fetchTodos()
    }
    
    func didTapIsCompleted(todoId: Int64) {
        interactor.completeTodo(todoId: todoId)
    }
}
    

extension TodoListPresenter: TodoListPresenterInteractorProtocol {
    func didFetch(todos: [TodoTableCellEntity]) {
        view?.show(todos: todos)
    }
    
    func didUpdated(todo: TodoTableCellEntity) {
        view?.update(todo: todo)
    }
}
