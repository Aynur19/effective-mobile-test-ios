//
//  TodoCoreDataModel.swift
//  EMCoreDataStack
//
//  Created by Aynur Nasybullin on 27.11.2024.
//
//

import Foundation
import CoreData
import EMCore

@objc(TaskEntity)
public class TodoCoreDataModel: NSManagedObject { }

extension TodoCoreDataModel {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoCoreDataModel> {
        return NSFetchRequest<TodoCoreDataModel>(entityName: entityName)
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var createdOn: Date
    @NSManaged public var isCompleted: Bool
    @NSManaged public var todoDescription: String
}

extension TodoCoreDataModel: Identifiable { }


extension TodoCoreDataModel {
    static let entityName = "\(TodoCoreDataModel.self)"

    enum Keys: String {
        case id
        case name
        case taskDescription
        case createdOn
        case isCompleted

        var key: String { self.rawValue }
    }
    
    static func create(context: NSManagedObjectContext, todo: Todo) -> TodoCoreDataModel {
        let todoModel = TodoCoreDataModel(context: context)
        todoModel.id = todo.id
        todoModel.name = todo.name
        todoModel.todoDescription = todo.description
        todoModel.createdOn = todo.createdOn
        todoModel.isCompleted = todo.isCompleted

        return todoModel
    }


    var emTask: Todo {
        Todo(
            id: id,
            name: name,    
            description: todoDescription,
            createdOn: createdOn,
            isCompleted: isCompleted
        )
    }


    static func geTaskFetchRequest(taskId: Int64) -> NSFetchRequest<TodoCoreDataModel> {
        let fetchRequest = TodoCoreDataModel.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            getIdPredicate(taskId),
        ])
        fetchRequest.fetchLimit = 1

        return fetchRequest
    }


    static func getTaskFetchRequest(
        isCompleted: Bool?,
        startDate: Date?,
        endDate: Date?,
        sortKeys: [(TodoCoreDataModel.Keys, Bool)]
    ) -> NSFetchRequest<TodoCoreDataModel> {
        let predicates = getPredicates(isCompleted: isCompleted, startDate: startDate, endDate: endDate)
        
        let fetchRequest = TodoCoreDataModel.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.sortDescriptors = sortKeys.map { getSortDescriptor($0.0, ascending: $0.1) }

        return fetchRequest
    }
    
    private static func getPredicates(isCompleted: Bool?, startDate: Date?, endDate: Date?) -> [NSPredicate] {
        var predicates = [NSPredicate]()
        if let isCompleted = isCompleted {
            predicates.append(getIsCompletedPredicate(isCompleted))
        }
        
        if let startDate = startDate {
            predicates.append(getCreatedOnStartPredicate(startDate))
        }
        
        if let endDate = endDate {
            predicates.append(getCreatedOnEndPredicate(endDate))
        }
        
        return predicates
    }
    
    private static func getIdPredicate(_ id: Int64) -> NSPredicate {
        NSPredicate(format: "\(Keys.id.key) == %@", NSNumber(value: id))
    }
    
    private static func getIsCompletedPredicate(_ isCompleted: Bool) -> NSPredicate {
        NSPredicate(format: "\(Keys.isCompleted.key) == %@", NSNumber(value: isCompleted))
    }
    
    private static func getCreatedOnStartPredicate(_ startDate: Date) -> NSPredicate {
        NSPredicate(format: "\(Keys.isCompleted.key) >= %@", startDate as NSDate)
    }
    
    private static func getCreatedOnEndPredicate(_ endDate: Date) -> NSPredicate {
        NSPredicate(format: "\(Keys.isCompleted.key) <= %@", endDate as NSDate)
    }
    
    private static func getSortDescriptor(_ key: Keys, ascending: Bool) -> NSSortDescriptor {
        NSSortDescriptor(key: key.key, ascending: ascending)
    }
}
