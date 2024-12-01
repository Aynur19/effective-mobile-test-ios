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
        case tasksCount
        
        public var string: String {
            NSLocalizedString(self.rawValue, tableName: "TodoList.Localizable", comment: "")
        }
    }
    
    public enum Images: ImageAssetsProtocol {
        case createToolbarBtn
        
        var name: String {
            return switch self {
                case .createToolbarBtn:     "square.and.pencil"
            }
        }
        
        public var image: UIImage {
            UIImage(systemName: name)!
        }
    }
}

