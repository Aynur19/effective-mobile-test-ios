//
//  TodoListInteractor.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 29.11.2024.
//

import Foundation
import EMCore
import EMNetworkingService
import EMTodoApiService

class TodoListInteractor {
    var presenter: TodoListPresenterInteractorProtocol!
    let todoApiService: TodoApiServiceProtocol = TodoApiService(
        networkService: NetworkingService(
            sessionConfiguration: .default, requestConfiguration: .init(maxRetries: 3, firstDelay: 2)
        )
    )
    
    let todoList = TodoListEntity()
    
    required init(presenter: TodoListPresenterInteractorProtocol) {
        self.presenter = presenter
    }
}


extension TodoListInteractor: TodoListInteractorProtocol {
    func fetchTodos() {
        guard let url = URL(string: AppConstants.todoApiUrlStr) else {
            return print("Can't get todo API URL from url string!")
        }
        
        todoApiService.fetchTodoList(url: url) { [weak self] result in
            guard let self else { return }
            
            switch result {
                case .success(let todos):
                    todoList.todos = todos.map { .create(todo: $0) }
                    presenter.didFetch(todos: todoList.todos)
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func completeTodo(todoId: Int64) {
        guard let todo = todoList.complete(todoId: todoId) else { return }
        
        presenter.didUpdated(todo: todo)
    }
}
