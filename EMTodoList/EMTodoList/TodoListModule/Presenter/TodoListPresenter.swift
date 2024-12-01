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
        interactor.completeTodo(for: todoId)
    }
    
    func didTapOnCell(todoId: Int64) {
        router.navigateToTodoDetail(for: todoId)
    }
    
    func didEnterSearch(searchText: String) {
        if searchText.isEmpty {
            interactor.fetchTodos()
        } else {
            interactor.fetchTodos(searchText: searchText)
        }
    }
    
    func didSelectToEdit(todoId: Int64) {
        router.navigateToTodoDetail(for: todoId)
    }
    
    func didSelectToShare(todoId: Int64) {
        // TODO: something
    }
    
    func didSelectToDelete(todoId: Int64) {
        interactor.deleteTodo(for: todoId)
    }
}
    

extension TodoListPresenter: TodoListPresenterInteractorProtocol {
    func didFetch(todos: [TodoTableCellEntity]) {
        view?.show(todos: todos)
    }
    
    func didUpdate(todo: TodoTableCellEntity) {
        view?.update(todo: todo)
    }
    
    func didDelete(todo: TodoTableCellEntity) {
        view?.delete(todo: todo)
    }
}


extension TodoListPresenter: TodoDetailModuleDelegate {
    func didDeleteTodo(_ todo: Todo) {
        view?.delete(todo: .create(todo: todo))
    }
    
    func didSaveTodo(_ todo: Todo) {
        view?.update(todo: .create(todo: todo))
    }
}
