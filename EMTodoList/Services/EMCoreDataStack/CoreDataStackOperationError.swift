//
//  CoreDataStackOperationError.swift
//  EMCoreDataStack
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

import Foundation
import EMCore

public enum CoreDataStackOperationError {
    case serviceIsNilError
    
    case notFoundByIdError(id: String)
    
    case fetchError(nsError: NSError)
    case saveError(nsError: NSError)
    case removeError(nsError: NSError)
    case deleteError(nsError: NSError)
    
    case notFoundDatabaseFileURL(database: CoreDataDatabase)
    case databaseDropError(database: CoreDataDatabase, nsError: NSError)
    case databaseFileRemoveError(database: CoreDataDatabase, nsError: NSError)
    case databaseReloadError(database: CoreDataDatabase, nsError: NSError)
    case unhandledError(nsError: NSError)
}


extension CoreDataStackOperationError: OperationErrorProtocol {
    public var debugMessage: String {
        switch self {
            case .serviceIsNilError:
                "Служба выполнения запросов к Core Data недоступна (nil)!"
                
                
            case .notFoundByIdError(let id):
                "Искомый объект по id ('\(id)') не найден в хранилище Core Data!"
                
                
            case .fetchError(let nsError):
                "Ошибка вытягивания данных из CoreData! NSError: \(nsError)"
                
            case .saveError(let nsError):
                "Ошибка сохранения данных через фоновый контекст (backgroundContext)! NSError: \(nsError)"
                
            case .unhandledError(let nsError):
                "Необработанная ошибка! NSError: \(nsError)"
                
            case .databaseDropError(let database, let nsError):
                "Не удалось выполнить запрос на удаление хранилища '\(database.name)' (Core Data)! NSError: \(nsError)"
                
            case .databaseFileRemoveError(let database, let nsError):
                "Не удалось успешно удалить файл хранилища '\(database.name)' (Core Data)! NSError: \(nsError)"
                
            case .databaseReloadError(let database, let nsError):
                "Не удалось перезагрузить хранилище '\(database.name)' (Core Data)! NSError: \(nsError)"
                
            case .notFoundDatabaseFileURL(let database):
                "Не удалось получить URL файла хранилища '\(database.name)' (Core Data)!"
                
            case .removeError(let nsError):
                "Не удалось выполнить запрос на перенос в список удаленных чата!  NSError: \(nsError)"
                
                
            case .deleteError(let nsError):
                "Не удалось выполнить запрос на удаление чата! NSError: \(nsError)"
        }
    }
}
