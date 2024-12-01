//
//  ContextMenuAssets.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 01.12.2024.
//

import UIKit

public struct ContextMenuAssets {
    public enum Strings: String, StringAssetsProtocol {
        case editAction
        case shareAction
        case deleteAction
        
        public var string: String {
            NSLocalizedString(self.rawValue, tableName: "ContextMenu.Localizable", comment: "")
        }
    }
    
    public enum Images: ImageAssetsProtocol {
        case editAction
        case shareAction
        case deleteAction
        
        var name: String {
            return switch self {
                case .editAction:       "square.and.pencil"
                case .shareAction:      "square.and.arrow.up"
                case .deleteAction:     "trash"
            }
        }
        
        public var image: UIImage {
            UIImage(systemName: self.name)!
        }
    }
}
