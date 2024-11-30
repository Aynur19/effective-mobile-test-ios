//
//  ManagerProvider.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

import Foundation
import CoreData
import EMCore
import EMNetworkingService
import EMCoreDataStack

typealias EMCoreDataStackManager = CoreDataStackProtocol & CoreDataStackTodoProtocol

public final class ManagerProvider {
    let coreDataStackManager: EMCoreDataStackManager
    
    init(
        todoPersistentContainer: NSPersistentContainer
    ) {
        coreDataStackManager = CoreDataStack(todoPersistentContainer: todoPersistentContainer)
    }
    
    static var shared: ManagerProvider!

    static func initialize(
        todoPersistentContainer: NSPersistentContainer
    ) {
        shared = ManagerProvider(todoPersistentContainer: todoPersistentContainer)
    }
}
