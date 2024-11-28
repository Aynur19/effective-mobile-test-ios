//
//  TaskCoreDataModel.swift
//  EMCoreDataStack
//
//  Created by Aynur Nasybullin on 27.11.2024.
//
//

import Foundation
import CoreData
import EMCore

@objc(TaskEntity)
public class TaskCoreDataModel: NSManagedObject { }

extension TaskCoreDataModel {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskCoreDataModel> {
        return NSFetchRequest<TaskCoreDataModel>(entityName: entityName)
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var createdOn: Date
    @NSManaged public var isCompleted: Bool
    @NSManaged public var taskDescription: String
}

extension TaskCoreDataModel: Identifiable { }


extension TaskCoreDataModel {
    static let entityName = "\(TaskCoreDataModel.self)"

    enum Keys: String {
        case id
        case name
        case taskDescription
        case createdOn
        case isCompleted

        var key: String { self.rawValue }
    }
    
    static func create(context: NSManagedObjectContext, emTask: EMTask) -> TaskCoreDataModel {
        let task = TaskCoreDataModel(context: context)
        task.id = emTask.id
        task.name = emTask.name
        task.taskDescription = emTask.taskDescription
        task.createdOn = emTask.createdOn
        task.isCompleted = emTask.isCompleted

        return task
    }


    var emTask: EMTask {
        EMTask(
            id: id,
            name: name,    
            taskDescription: taskDescription,
            createdOn: createdOn,
            isCompleted: isCompleted
        )
    }


    static func geTaskFetchRequest(taskId: Int64) -> NSFetchRequest<TaskCoreDataModel> {
        let fetchRequest = TaskCoreDataModel.fetchRequest()
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
        sortKeys: [(TaskCoreDataModel.Keys, Bool)]
    ) -> NSFetchRequest<TaskCoreDataModel> {
        let predicates = getPredicates(isCompleted: isCompleted, startDate: startDate, endDate: endDate)
        
        let fetchRequest = TaskCoreDataModel.fetchRequest()
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
