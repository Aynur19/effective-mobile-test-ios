//
//  CoreDataStack.Todo.swift
//  EMCoreDataStack
//
//  Created by Aynur Nasybullin on 30.11.2024.
//

import CoreData
import EMCore

public protocol CoreDataStackTodoProtocol {
    func fetchTodos(
        isCompleted: Bool?,
        startDate: Date?,
        endDate: Date?,
        sortKeys: [(Todo.Keys, Bool)],
        completion: @escaping (Result<[Todo], CoreDataStackOperationError>) -> Void
    )
    
    func fetchTodos(
        searchText: String,
        sortKeys: [(Todo.Keys, Bool)],
        completion: @escaping (Result<[Todo], CoreDataStackOperationError>) -> Void
    )
    
    func saveTodos(
        _ todos: [Todo],
        completion: @escaping (CoreDataStackOperationError?) -> Void
    )
    
    
    func fetchTodo(
        by id: Int64,
        completion: @escaping (Result<Todo, CoreDataStackOperationError>) -> Void
    )
    
    func deleteTodo(
        by id: Int64,
        completion: @escaping (CoreDataStackOperationError?) -> Void
    )
    
    func saveTodo(
        _ todo: Todo,
        completion: @escaping (CoreDataStackOperationError?) -> Void
    )
}


extension CoreDataStack: CoreDataStackTodoProtocol {
    private var mainContext: NSManagedObjectContext { todoPersistentContainer.viewContext }
    
    private func saveBackgroundContext(_ context: NSManagedObjectContext) throws {
        let notificationCenter = NotificationCenter.default
        let observer = notificationCenter.addObserver(
            forName: .NSManagedObjectContextDidSave,
            object: context,
            queue: .main
        ) { [weak self] notification in
            logger.debug("Слияние изменений с основным контекстом...")
            self?.mainContext.mergeChanges(fromContextDidSave: notification)
        }
        
        try context.performAndWait {
            do {
                try context.save()
                logger.debug("Данные сохранены в фоновом контексте!")
            } catch let nsError as NSError {
                logger.debug("Не удалось сохранить данные в фоновом контексте: \(nsError), \(nsError.userInfo)")
                throw CoreDataStackOperationError.saveError(nsError: nsError)
            }
        }
        
        notificationCenter.removeObserver(observer)
    }
    
    public func fetchTodos(
        isCompleted: Bool?,
        startDate: Date?,
        endDate: Date?,
        sortKeys: [(Todo.Keys, Bool)],
        completion: @escaping (Result<[Todo], CoreDataStackOperationError>) -> Void
    ) {
        let operation = CoreDataStackOperation.searchTodos
        let context = todoPersistentContainer.newBackgroundContext()
        logger.info(message: operation.logExecutionMessage())
        
        context.perform { [weak self] in
            guard let self else {
                return completion(.failure(getLoggedServiceNilError(for: operation)))
            }
            
            do {
                let fetchedTodos = try fetchTodosRequest(
                    context,
                    isCompleted: isCompleted,
                    startDate: startDate,
                    endDate: endDate,
                    sortKeys: TodoCoreDataModel.mapSortKeys(sortKeys: sortKeys)
                ).map { $0.todo }
                
                logger.info(message: operation.logSuccessMessage())
                return completion(.success(fetchedTodos))
            } catch let error as CoreDataStackOperationError {
                return completion(.failure(getLoggedError(for: operation, error: error)))
            } catch let nsError as NSError {
                return completion(.failure(getLoggedError(for: operation, error: .fetchError(nsError: nsError))))
            }
        }
    }
    
    public func fetchTodos(
        searchText: String,
        sortKeys: [(Todo.Keys, Bool)],
        completion: @escaping (Result<[Todo], CoreDataStackOperationError>) -> Void
    ) {
        let operation = CoreDataStackOperation.fetchTodos
        let context = todoPersistentContainer.newBackgroundContext()
        logger.info(message: operation.logExecutionMessage())
        
        context.perform { [weak self] in
            guard let self else {
                return completion(.failure(getLoggedServiceNilError(for: operation)))
            }
            
            do {
                let fetchedTodos = try fetchTodosRequest(
                    context,
                    searchText: searchText,
                    sortKeys: TodoCoreDataModel.mapSortKeys(sortKeys: sortKeys)
                ).map { $0.todo }
                
                logger.info(message: operation.logSuccessMessage())
                return completion(.success(fetchedTodos))
            } catch let error as CoreDataStackOperationError {
                return completion(.failure(getLoggedError(for: operation, error: error)))
            } catch let nsError as NSError {
                return completion(.failure(getLoggedError(for: operation, error: .fetchError(nsError: nsError))))
            }
        }
    }
    
    public func saveTodos(_ todos: [Todo], completion: @escaping (CoreDataStackOperationError?) -> Void) {
        let operation = CoreDataStackOperation.saveTodos
        let context = todoPersistentContainer.newBackgroundContext()
        logger.info(message: operation.logExecutionMessage())
        
        context.perform { [weak self] in
            guard let self else {
                return completion(getLoggedServiceNilError(for: operation))
            }
            
            do {
                try saveTodosRequest(context, todos: todos)
                
                logger.info(message: operation.logSuccessMessage())
                return completion(nil)
            } catch let error as CoreDataStackOperationError {
                return completion(getLoggedError(for: operation, error: error))
            } catch let nsError as NSError {
                return completion(getLoggedError(for: operation, error: .saveError(nsError: nsError)))
            }
        }
    }
    

    public func fetchTodo(by id: Int64, completion: @escaping (Result<Todo, CoreDataStackOperationError>) -> Void) {
        let operation = CoreDataStackOperation.fetchTodo
        let context = todoPersistentContainer.newBackgroundContext()
        logger.info(message: operation.logExecutionMessage())
        
        do {
            guard let fetchedTodo = try fetchTodoRequest(context, todoId: id)?.todo else {
                return completion(.failure(.notFoundByIdError(id: String(id))))
            }
            
            logger.info(message: operation.logSuccessMessage())
            return completion(.success(fetchedTodo))
        } catch let error as CoreDataStackOperationError {
            return completion(.failure(getLoggedError(for: operation, error: error)))
        } catch let nsError as NSError {
            return completion(.failure(getLoggedError(for: operation, error: .fetchError(nsError: nsError))))
        }
    }
    
    public func deleteTodo(by id: Int64, completion: @escaping (CoreDataStackOperationError?) -> Void) {
        let operation = CoreDataStackOperation.deleteTodo
        let context = todoPersistentContainer.newBackgroundContext()
        logger.info(message: operation.logExecutionMessage())
        
        do {
            try deleteTodoRequest(context, todoId: id)
            
            logger.info(message: operation.logSuccessMessage())
            return completion(nil)
        } catch let error as CoreDataStackOperationError {
            return completion(getLoggedError(for: operation, error: error))
        } catch let nsError as NSError {
            return completion(getLoggedError(for: operation, error: .deleteError(nsError: nsError)))
        }
    }
    
    
    public func saveTodo(_ todo: Todo, completion: @escaping (CoreDataStackOperationError?) -> Void) {
        let operation = CoreDataStackOperation.saveTodo
        let context = todoPersistentContainer.newBackgroundContext()
        logger.info(message: operation.logExecutionMessage())
        
        do {
            try saveTodoRequest(context, todo: todo)
            
            logger.info(message: operation.logSuccessMessage())
            return completion(nil)
        } catch let error as CoreDataStackOperationError {
            return completion(getLoggedError(for: operation, error: error))
        } catch let nsError as NSError {
            return completion(getLoggedError(for: operation, error: .saveError(nsError: nsError)))
        }
    }
}


extension CoreDataStack {
    private func fetchTodosRequest(
        _ context: NSManagedObjectContext,
        isCompleted: Bool?,
        startDate: Date?,
        endDate: Date?,
        sortKeys: [(TodoCoreDataModel.Keys, Bool)]
    ) throws -> [TodoCoreDataModel]  {
        do {
            let fetchRequest = TodoCoreDataModel.getTodoFetchRequest(
                isCompleted: isCompleted,
                startDate: startDate,
                endDate: endDate,
                sortKeys: sortKeys
            ) 
            
            return try context.fetch(fetchRequest)
        } catch let nsError as NSError {
            throw CoreDataStackOperationError.fetchError(nsError: nsError)
        }
    }
    
    
    private func fetchTodosRequest(
        _ context: NSManagedObjectContext,
        searchText: String,
        sortKeys: [(TodoCoreDataModel.Keys, Bool)]
    ) throws -> [TodoCoreDataModel]  {
        do {
            let fetchRequest = TodoCoreDataModel.getTodoFetchRequest(
                searchText: searchText,
                sortKeys: sortKeys
            )
            
            return try context.fetch(fetchRequest)
        } catch let nsError as NSError {
            throw CoreDataStackOperationError.fetchError(nsError: nsError)
        }
    }
    
    
    private func saveTodosRequest(
        _ context: NSManagedObjectContext,
        todos: [Todo]
    ) throws {
        let ids = todos.map { $0.id }
        let fetchRequest = TodoCoreDataModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(TodoCoreDataModel.Keys.id.key) IN %@", ids)
        
        let existingTodos = try context.fetch(fetchRequest)
        var existingTodosDict = [Int64: TodoCoreDataModel]()
        existingTodos.forEach {
            existingTodosDict[$0.id] = $0
        }

        for todo in todos {
            if let existingTodo = existingTodosDict[todo.id] {
                existingTodo.update(todo: todo)
            } else {
                _ = TodoCoreDataModel.create(context: context, todo: todo)
            }

            if context.hasChanges {
                try context.save()
            }
        }
        
        try saveBackgroundContext(context)
    }

    
    private func fetchTodoRequest(_ context: NSManagedObjectContext, todoId: Int64) throws -> TodoCoreDataModel? {
        do {
            let fetchRequest = TodoCoreDataModel.getTodoFetchRequest(todoId: todoId)
            return try context.fetch(fetchRequest).first
        } catch let nsError as NSError {
            throw CoreDataStackOperationError.fetchError(nsError: nsError)
        }
    }
    
    private func saveTodoRequest(_ context: NSManagedObjectContext, todo: Todo) throws {
        guard let fetchedTodo = try fetchTodoRequest(context, todoId: todo.id) else {
            throw CoreDataStackOperationError.notFoundByIdError(id: String(todo.id))
        }
        
        fetchedTodo.name = todo.name
        fetchedTodo.todoDescription = todo.description
        fetchedTodo.createdOn = todo.createdOn
        fetchedTodo.isCompleted = todo.isCompleted
        
        try saveBackgroundContext(context)
    }
    
    
    
    private func deleteTodoRequest(_ context: NSManagedObjectContext, todoId: Int64) throws {
        guard let fetchedTodo = try fetchTodoRequest(context, todoId: todoId) else {
            throw CoreDataStackOperationError.notFoundByIdError(id: String(todoId))
        }
        
        context.delete(fetchedTodo)
        try saveBackgroundContext(context)
    }
}
