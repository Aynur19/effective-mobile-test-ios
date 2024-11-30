//
//  TodoListInteractor.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 29.11.2024.
//

import Foundation
import OSLog
import EMCore
import EMCoreDataStack
import EMNetworkingService
import EMTodoApiService

fileprivate let logger = Logger(subsystem: "EMToDoList.TodoListModule", category: "Todo List Module")

class TodoListInteractor {
    private enum PreferencesKeys: String {
        case todosIsDownloadFromApi
    }
    
    var presenter: TodoListPresenterInteractorProtocol!
    let todoApiService: TodoApiServiceProtocol = TodoApiService(
        networkService: NetworkingService(
            sessionConfiguration: .default, requestConfiguration: .init(maxRetries: 3, firstDelay: 2)
        )
    )
    let userDefaults = UserDefaults.standard
    let todoList = TodoListEntity()
    
    var coreDataStackManager: EMCoreDataStackManager { ManagerProvider.shared.coreDataStackManager }
    
    
    required init(presenter: TodoListPresenterInteractorProtocol) {
        self.presenter = presenter
    }
}


extension TodoListInteractor: TodoListInteractorProtocol {
    func fetchTodos() {
        fetchTodosFromCoreData { [weak self] todos in
            self?.updateTodos(todos: todos)
        }
        
        if !userDefaults.bool(forKey: PreferencesKeys.todosIsDownloadFromApi.rawValue) {
            fetchTodosFromNetwork { [weak self] todos in
                self?.saveTodos(todos: todos) {
                    self?.userDefaults.set(true, forKey: PreferencesKeys.todosIsDownloadFromApi.rawValue)
                    
                    self?.fetchTodosFromCoreData { todos in
                        self?.updateTodos(todos: todos)
                    }
                }
            }
        }
    }
    
    func fetchTodos(searchText: String) {
        searchTodos(searchText: searchText) { [weak self] todos in
            self?.updateTodos(todos: todos)
        }
    }
    
    func completeTodo(todoId: Int64) {
        guard let todo = todoList.complete(todoId: todoId) else { return }
        
        presenter.didUpdated(todo: todo)
    }
}

extension TodoListInteractor {
    private func updateTodos(todos: [Todo]) {
        todoList.todos = todos.map { .create(todo: $0) }
        presenter.didFetch(todos: todoList.todos)
    }
    
    private func fetchTodosFromNetwork(completion: @escaping ([Todo]) -> Void) {
        guard let url = URL(string: AppConstants.todoApiUrlStr) else {
            return logger.error(message: "Не удалось получить URL из строки для загрузки задач из сервера!")
        }
        
        logger.error(message: "Запрос на получение данных из сервера...")
        todoApiService.fetchTodoList(url: url) { result in
            switch result {
                case .success(let todos):
                    completion(todos)
                    
                case .failure(let error):
                    logger.error(message: error.debugMessage)
            }
        }
    }
    
    private func fetchTodosFromCoreData(completion: @escaping ([Todo]) -> Void) {
        logger.error(message: "Запрос на получение данных из CoreData...")
        
        coreDataStackManager.fetchTodos(
            isCompleted: nil,
            startDate: nil,
            endDate: nil,
            sortKeys: []
        ) { result in
            switch result {
                case .success(let todos):
                    completion(todos)
                    
                case .failure(let error):
                    logger.error(message: error.debugMessage)
            }
        }
    }
    
    private func searchTodos(searchText: String, completion: @escaping ([Todo]) -> Void) {
        logger.error(message: "Запрос на получение данных из CoreData по поисковой строке...")
        
        coreDataStackManager.fetchTodos(
            searchText: searchText,
            sortKeys: []
        ) { result in
            switch result {
                case .success(let todos):
                    completion(todos)
                    
                case .failure(let error):
                    logger.error(message: error.debugMessage)
            }
        }
    }
    
    private func saveTodos(todos: [Todo], completion: @escaping () -> Void) {
        coreDataStackManager.saveTodos(todos) { error in
            if let error = error {
                return logger.error(message: error.debugMessage)
            }
            
            completion()
        }
    }
}
