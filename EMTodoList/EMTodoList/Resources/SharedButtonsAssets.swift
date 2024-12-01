//
//  SharedButtonsAssets.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 02.12.2024.
//

import Foundation

public struct SharedButtonsAssets {
    public enum Strings: String, StringAssetsProtocol {
        case ok
        case done
        
        public var string: String {
            NSLocalizedString(self.rawValue, tableName: "SharedButtons.Localizable", comment: "")
        }
    }
}
