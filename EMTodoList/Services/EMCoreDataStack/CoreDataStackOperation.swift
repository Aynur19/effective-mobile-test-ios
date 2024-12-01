//
//  CoreDataStackOperation.swift
//  EMCoreDataStack
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

import Foundation
import EMCore

public enum CoreDataStackOperation {
    case fetchTodos
    case searchTodos
    case saveTodos
    
    case fetchTodo
    case createTodo
    case saveTodo
    case deleteTodo
    
    case dropDatabase(database: CoreDataDatabase)
    case removeDatabaseFile(database: CoreDataDatabase)
    case reloadDatabase(database: CoreDataDatabase)
}


extension CoreDataStackOperation: OperationProtocol {
    public var id: Int {
        switch self {
            case .fetchTodos:                   101
            case .searchTodos:                  102
            case .saveTodos:                    103
                
            case .fetchTodo:                    201
            case .createTodo:                   202
            case .saveTodo:                     203
            case .deleteTodo:                   204
                
            case .dropDatabase(.todo):          1001
            case .removeDatabaseFile(.todo):    1002
            case .reloadDatabase(.todo):        1003
        }
    }
    
    public var name: String {
        switch self {
            case .fetchTodos:
                "Запрос на получение списка задач пользователя (Core Data)"
                
            case .searchTodos:
                "Запрос на получение списка задач пользователя по поисковой строке (Core Data)"
                
            case .saveTodos:
                "Запрос на сохранение списка задач пользователя (Core Data)"
                
                
            case .fetchTodo:
                "Запрос на получение конкретной задачи (Core Data)"
                
            case .saveTodo:
                "Запрос на сохранение конкретной задачи (Core Data)"
                
            case .createTodo:
                "Запрос на создание новой задачи (Core Data)"
                
            case .deleteTodo:
                "Запрос на удаление конкретной задачи (Core Data)"
                
                
            case .dropDatabase(let database):
                "Запрос на удаление хранилища '\(database.name)'"
                
            case .removeDatabaseFile(let database):
                "Удаление из файловой системы файла хранилища '\(database.name)'"
                
            case .reloadDatabase(let database):
                "Запрос на пересоздание хранилища '\(database.name)'"
        }
    }
}
