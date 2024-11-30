//
//  TaskDetailAssets.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 28.11.2024.
//

import UIKit

public struct TodoDetailAssets {
    public enum Colors: String, ColorAssetsProtocol {
        case todoNameFg
        case todoCreatedOnFg
        case todoDescriptionFg
        
        public var color: UIColor {
            UIColor(named: "Colors/TodoDetail/" + self.rawValue) ?? .red
        }
    }
    
    public enum Strings: String, StringAssetsProtocol {
        case todo
        case todoName
        case todoDescription
        
        public var string: String {
            NSLocalizedString(self.rawValue, tableName: "TodoDetail.Localizable", comment: "")
        }
    }
}
