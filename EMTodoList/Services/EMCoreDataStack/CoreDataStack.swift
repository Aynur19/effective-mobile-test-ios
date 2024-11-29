//
//  CoreDataStack.swift
//  EMCoreDataStack
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

import CoreData
import OSLog

let logger = Logger(subsystem: "EMCoreDataStack", category: "Core Data Stask")

func getLoggedServiceNilError(for operation: CoreDataStackOperation) -> CoreDataStackOperationError {
    getLoggedError(for: operation, error: .serviceIsNilError)
}

func getLoggedError(
    for operation: CoreDataStackOperation,
    error: CoreDataStackOperationError
) -> CoreDataStackOperationError {
    logger.error(message: operation.logErrorMessage(error: error))
    return error
}


public protocol CoreDataStackProtocol {
    func resetDatabase(database: CoreDataDatabase) async -> CoreDataStackOperationError?
}


public final class CoreDataStack {
    typealias TaskKeys = TodoCoreDataModel.Keys
    
    let todoPersistentContainer: NSPersistentContainer
    
    public init(
        todoPersistentContainer: NSPersistentContainer
    ) {
        self.todoPersistentContainer = todoPersistentContainer
    }
}


extension CoreDataStack: CoreDataStackProtocol {
    public func resetDatabase(database: CoreDataDatabase) async -> CoreDataStackOperationError? {
        logger.info("Инициация процесса удаления базы данных чатов перед выходом")
        
        var operationError: CoreDataStackOperationError?
        let persistentContainer: NSPersistentContainer
        
        switch database {
            case .todo:
                persistentContainer = todoPersistentContainer
        }
        
        do {
            let storeURL = try await dropDatabase(database: database, persistentContainer: persistentContainer)
            logger.info("Все данные удалены!")
            
            try removeDatabaseFaile(database: database, storeURL: storeURL)
            logger.info("Удален файл базы данных!")
            
            reloadDatabase(database: database, persistentContainer: persistentContainer)
            logger.info("База данных пересоздана!")
        } catch let error as CoreDataStackOperationError {
            operationError = error
        } catch {
            operationError = .unhandledError(nsError: error as NSError)
        }
        
        return operationError
    }
}


extension CoreDataStack {
    private func dropDatabase(database: CoreDataDatabase, persistentContainer: NSPersistentContainer) async throws -> URL {
        let operation = CoreDataStackOperation.dropDatabase(database: database)
        var operationError: CoreDataStackOperationError
        logger.info(message: operation.logExecutionMessage())
        
        let storeCoordinator = persistentContainer.persistentStoreCoordinator
        guard let storeURL = persistentContainer.persistentStoreCoordinator.persistentStores.first?.url else {
            operationError = .notFoundDatabaseFileURL(database: database)
            logger.error(message: operation.logErrorMessage(error: operationError))
            throw operationError
        }

        do {
            try await persistentContainer.performBackgroundTask { context in
                try storeCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
                logger.info(message: operation.logSuccessMessage())
            }
        } catch let nsError as NSError {
            operationError = .databaseDropError(database: database, nsError: nsError)
            logger.error(message: operation.logErrorMessage(error: operationError))
            throw operationError
        }
        
        return storeURL
    }
    
    
    private func removeDatabaseFaile(database: CoreDataDatabase, storeURL: URL) throws {
        let operation = CoreDataStackOperation.removeDatabaseFile(database: database)
        var operationError: CoreDataStackOperationError
        logger.info(message: operation.logExecutionMessage())
        
        do {
            try FileManager.default.removeItem(at: storeURL)
            logger.info(message: operation.logSuccessMessage())
        } catch {
            operationError = .databaseFileRemoveError(database: database, nsError: error as NSError)
            logger.error(message: operation.logErrorMessage(error: operationError))
            throw operationError
        }
    }
    
    
    private func reloadDatabase(database: CoreDataDatabase, persistentContainer: NSPersistentContainer) {
        let operation = CoreDataStackOperation.reloadDatabase(database: database)
        logger.info(message: operation.logExecutionMessage())
        
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                let operationError = CoreDataStackOperationError.databaseReloadError(database: database, nsError: error as NSError)
                logger.error(message: operation.logErrorMessage(error: operationError))
                fatalError("Не удалось загрузить хранилище: \(error)")
            }
            
            logger.info(message: operation.logSuccessMessage())
        }
    }
}
