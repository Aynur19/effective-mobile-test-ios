//
//  TaskDetailAssets.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 28.11.2024.
//

import UIKit

public struct TaskDetailAssets {
    public enum Colors: String, ColorAssetsProtocol {
        case taskNameFg
        case taskCreatedOnFg
        case taskDescriptionFg
        
        public var color: UIColor {
            UIColor(named: "Colors/TaskDetail/" + self.rawValue) ?? .red
        }
    }
    
    public enum Strings: String, StringAssetsProtocol {
        case task
        case taskName
        case taskDescription
        
        public var string: String {
            NSLocalizedString(self.rawValue, tableName: "TaskDetail.Localizable", comment: "")
        }
    }
}
