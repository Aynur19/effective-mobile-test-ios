//
//  TaskEntity.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 28.11.2024.
//

import Foundation

struct TaskDetailEntity {
    let id: Int64
    
    var name: String
    var taskDescription: String
    
    var createdOn: Date
    var isCompleted: Bool
}
