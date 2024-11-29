//
//  TodoApiService.swift
//  EMTodoApiService
//
//  Created by Aynur Nasybullin on 29.11.2024.
//

import Foundation
import EMCore
import EMNetworkingService

public protocol TodoApiServiceProtocol {
    func fetchTodoList(url: URL, completion: @escaping (Result<[Todo], NetworkingServiceError>) -> Void)
}


public final class TodoApiService {
    private let networkService: NetworkingServiceProtocol
    
    public init(networkService: NetworkingServiceProtocol) {
        self.networkService = networkService
    }
}

extension TodoApiService: TodoApiServiceProtocol {
    public func fetchTodoList(url: URL, completion: @escaping (Result<[Todo], NetworkingServiceError>) -> Void) {
        networkService.fetchData(url: url, responseDtoType: TodoListResponseDto.self) { result in
            switch result {
                case .success(let responseDto):
                    let tasks = Todo.create(todoList: responseDto)
                    completion(.success(tasks))
                
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
