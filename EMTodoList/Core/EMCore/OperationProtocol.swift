//
//  OperationProtocol.swift
//  EMCore
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

import Foundation

public protocol OperationProtocol: EnumProtocol { }

public protocol OperationErrorProtocol: AppErrorProtocol { }


extension OperationProtocol {
    public func logExecutionMessage() -> String {
        "Выполняется операция: \(name)..."
    }
    
    public func logResultProcessingMessage() -> String {
        "Обработка результата операция: \(name)..."
    }
    
    public func logErrorMessage(error: OperationErrorProtocol?) -> String {
        "\t Результат операции '\(name)' -> Ошибка: \(error?.debugMessage ?? "nil")"
    }
    
    
    public func logRouteErrorMessage() -> String {
        "\t Не удалось получить URL или Endpoint для выполнения операции '\(name)'!"
    }
    
    
    public func logSuccessMessage() -> String {
        "\t Результат операции '\(name)' -> Успешно"
    }
    
    public func logUserChangedMessage() -> String {
        "\t Результат операции не обработан по причине смены пользователя!"
    }
}
