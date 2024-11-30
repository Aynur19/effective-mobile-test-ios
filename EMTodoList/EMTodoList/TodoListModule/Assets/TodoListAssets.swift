//
//  TodoListAssets.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 30.11.2024.
//

import UIKit

public struct TodoListAssets {
    public enum Strings: String, StringAssetsProtocol {
        case viewTitle
        case searchPlaceholder
        
        public var string: String {
            NSLocalizedString(self.rawValue, tableName: "TodoList.Localizable", comment: "")
        }
    }
}

