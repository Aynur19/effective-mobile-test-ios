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
    
    required init(presenter: TodoDetailPresenterInteractorProtocol) {
        self.presenter = presenter
    }
    
    private var coreDataStack: EMCoreDataStackManager {
        ManagerProvider.shared.coreDataStackManager
    }

    func fetchTodo(by id: Int64) {
        guard id > 0 else {
            todo = .getNewEmpty()
            return presenter.didFetch(todo: todo)
        }
        
        fetchTodo(by: id) { [weak self] todo in
            self?.presenter.didFetch(todo: todo)
        }
    }
    
    func saveTodo(_ todo: TodoDetailEntity) {
        if todo != self.todo {
            self.todo = todo
            
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
    
    func saveTodo(completion: @escaping () -> Void) {
        coreDataStack.saveTodo(todo.todo) { error in
            if let error {
                return logger.error(message: error.debugMessage)
            }
            completion()
        }
    }
}
