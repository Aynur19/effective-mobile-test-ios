//
//  CoreDataStackOperation.swift
//  EMCoreDataStack
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

import Foundation
import EMCore

public enum CoreDataStackOperation {
    case fetchTasks
    case saveTasks
    
    case fetchTask
    case saveTask
    case deleteTask
    
    case dropDatabase(database: CoreDataDatabase)
    case removeDatabaseFile(database: CoreDataDatabase)
    case reloadDatabase(database: CoreDataDatabase)
}


extension CoreDataStackOperation: OperationProtocol {
    public var id: Int {
        switch self {
            case .fetchTasks:                   101
            case .saveTasks:                    102
                
            case .fetchTask:                    201
            case .saveTask:                     202
            case .deleteTask:                   203
                
            case .dropDatabase(.todo):          1001
            case .removeDatabaseFile(.todo):    1002
            case .reloadDatabase(.todo):        1003
        }
    }
    
    public var name: String {
        switch self {
            case .fetchTasks:
                "Запрос на получение списка задач пользователя (Core Data)"
                
            case .saveTasks:
                "Запрос на сохранение списка задач пользователя (Core Data)"
                
                
            case .fetchTask:
                "Запрос на получение конкретной задачи (Core Data)"
                
            case .saveTask:
                "Запрос на сохранение конкретной задачи (Core Data)"
                
            case .deleteTask:
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
