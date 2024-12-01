//
//  TodoDetailInteractor.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 28.11.2024.
//

import Foundation
import OSLog
import EMCore
import EMCoreDataStack

fileprivate let logger = Logger(subsystem: "EMToDoList.TodoDetailModule", category: "Todo Detail Module")

class TodoDetailInteractor: TodoDetailInteractorProtocol {
    private var todo: TodoDetailEntity!
    private let presenter: TodoDetailPresenterInteractorProtocol
    private let isNewTodo: Bool
    
    required init(
        presenter: TodoDetailPresenterInteractorProtocol,
        isNewTodo: Bool
    ) {
        self.presenter = presenter
        self.isNewTodo = isNewTodo
        
        if isNewTodo {
            todo = .getNewEmpty()
        }
    }
    
    private var coreDataStack: EMCoreDataStackManager {
        ManagerProvider.shared.coreDataStackManager
    }

    func fetchTodo(by id: Int64) {
        if isNewTodo {
            return presenter.didFetch(todo: todo)
        }
        
        fetchTodo(by: id) { [weak self] todo in
            self?.todo = todo
            self?.presenter.didFetch(todo: self?.todo)
        }
    }
    
    func saveTodo(_ todo: TodoDetailEntity) {
        guard todo != self.todo else { return }
        
        self.todo = todo
        
        if isNewTodo {
            createTodo { [weak self] in
                self?.presenter.didCreate(todo: todo)
            }
        } else {
            saveTodo { [weak self] in
                self?.presenter.didSave(todo: todo)
            }
        }
    }
}


extension TodoDetailInteractor {
    func fetchTodo(by id: Int64, completion: @escaping (TodoDetailEntity?) -> Void) {
        coreDataStack.fetchTodo(by: id) { result in
            switch result {
                case .success(let todo):
                    completion(.create(todo: todo))
                    
                case .failure(let error):
                    logger.error(message: error.debugMessage)
                    completion(nil)
            }
        }
    }
    
    func createTodo(completion: @escaping () -> Void) {
        coreDataStack.createTodo(todo.todo) { error in
            if let error {
                return logger.error(message: error.debugMessage)
            }
            completion()
        }
    }
    
    func saveTodo(completion: @escaping () -> Void) {
        coreDataStack.saveTodo(todo.todo) { error in
            if let error {
                return logger.error(message: error.debugMessage)
            }
            completion()
        }
    }
}
