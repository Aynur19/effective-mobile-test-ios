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

@objc(TodoCoreDataModel)
public class TodoCoreDataModel: NSManagedObject { }

extension TodoCoreDataModel {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoCoreDataModel> {
        return NSFetchRequest<TodoCoreDataModel>(entityName: entityName)
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var createdOn: Date
    @NSManaged public var createdOnStr: String
    @NSManaged public var isCompleted: Bool
    @NSManaged public var todoDescription: String
}

extension TodoCoreDataModel: Identifiable { }


extension TodoCoreDataModel {
    static let entityName = "\(TodoCoreDataModel.self)"

    enum Keys: String {
        case id
        case name
        case todoDescription
        case createdOn
        case createdOnStr
        case isCompleted

        var key: String { self.rawValue }
    }
    
    static func create(context: NSManagedObjectContext, todo: Todo) -> TodoCoreDataModel {
        let todoModel = TodoCoreDataModel(context: context)
        todoModel.id = todo.id
        todoModel.name = todo.name
        todoModel.todoDescription = todo.description
        todoModel.createdOn = todo.createdOn
        todoModel.createdOnStr = todo.createdOn.todoShortDate
        todoModel.isCompleted = todo.isCompleted

        return todoModel
    }


    var todo: Todo {
        Todo(
            id: id,
            name: name,    
            description: todoDescription,
            createdOn: createdOn,
            isCompleted: isCompleted
        )
    }
    
    func update(todo: Todo) {
        name = todo.name
        todoDescription = todo.description
        createdOn = todo.createdOn
        isCompleted = todo.isCompleted
    }

    static func mapSortKeys(sortKeys: [(Todo.Keys, Bool)]) -> [(Keys, Bool)] {
        sortKeys.map { item in
            return switch item.0 {
                case .id:               (.id, item.1)
                case .name:             (.name, item.1)
                case .description:      (.todoDescription, item.1)
                case .createdOn:        (.createdOn, item.1)
                case .isCompleted:      (.isCompleted, item.1)
            }
        }
    }

    static func getTodoFetchRequest(todoId: Int64) -> NSFetchRequest<TodoCoreDataModel> {
        let fetchRequest = TodoCoreDataModel.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            getIdPredicate(todoId),
        ])
        fetchRequest.fetchLimit = 1

        return fetchRequest
    }
    
    
    static func getTodoFetchRequest(
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
    
    
    static func getTodoFetchRequest(
        searchText: String,
        sortKeys: [(TodoCoreDataModel.Keys, Bool)]
    ) -> NSFetchRequest<TodoCoreDataModel> {
        let predicates = [
            getSearchTextPredicate(searchText)
        ]
        
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
    
    private static func getSearchTextPredicate(_ searchText: String) -> NSPredicate {
        let nameKey = TodoCoreDataModel.Keys.name.key
        let descriptionKey = TodoCoreDataModel.Keys.todoDescription.key
        let createdOnStrKey = TodoCoreDataModel.Keys.createdOnStr.key
        
        let nsSearchText = searchText as NSString
        
        return NSPredicate(
            format: "\(nameKey) CONTAINS[cd] %@ OR \(descriptionKey) CONTAINS[cd] %@ OR \(createdOnStrKey) CONTAINS[cd] %@",
            nsSearchText, nsSearchText, nsSearchText
        )
    }
    
    private static func getSortDescriptor(_ key: Keys, ascending: Bool) -> NSSortDescriptor {
        NSSortDescriptor(key: key.key, ascending: ascending)
    }
}
