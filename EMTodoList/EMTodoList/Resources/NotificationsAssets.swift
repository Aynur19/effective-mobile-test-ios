//
//  NotificationsAssets.swift
//  EMTodoList
//
//  Created by Aynur Nasybullin on 01.12.2024.
//

import Foundation

public struct NotificationsAssets {
    public enum Strings: String, StringAssetsProtocol {
        case titleError
        
        case messageNotFetchTodoByIdError
        
        public var string: String {
            NSLocalizedString(self.rawValue, tableName: "Notifications.Localizable", comment: "")
        }
    }
}
