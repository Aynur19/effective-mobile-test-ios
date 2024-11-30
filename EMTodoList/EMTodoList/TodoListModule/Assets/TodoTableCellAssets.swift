//
//  TodoTableCellAssets.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 30.11.2024.
//

import UIKit

public struct TodoTableCellAssets {
    public enum Colors: String, ColorAssetsProtocol {
        case todoCreatedOnFg
        case todoIsCompletedFg
        case todoIsCompletedLabelsFg
        case todoIsNotCompletedFg
        case todoIsNotCompletedLabelsFg
        
        public var color: UIColor {
            UIColor(named: "Colors/TodoTableCell/" + self.rawValue) ?? .red
        }
    }
    
    
    public enum Images: String, ImageAssetsProtocol {
        case todoIsCompleted
        case todoIsNotCompleted
        
        var key: String {
            return switch self {
                case .todoIsCompleted:      "checkmark.circle"
                case .todoIsNotCompleted:   "circle"
            }
        }
        
        public var image: UIImage {
            return switch self {
                case .todoIsCompleted, .todoIsNotCompleted:
                    UIImage(systemName: key) ?? .checkmark
            }
        }
    }
}
