//
//  CoreDataDatabase.swift
//  EMCoreDataStack
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

import EMCore

public enum CoreDataDatabase: EnumProtocol {
    case todo

    public var id: Int {
        return switch self {
            case .todo:     1
        }
    }
    
    public var name: String {
        return switch self {
            case .todo:     "База данных задач (Core Data)"
        }
    }
}
