//
//  TodoListResponseDto.swift
//  EMTodoApiService
//
//  Created by Aynur Nasybullin on 29.11.2024.
//

public struct TodoListResponseDto {
    public let total: Int64
    public let skip: Int64
    public let limit: Int64
    
    public let todos: [TodoResponseDto]
}

extension TodoListResponseDto: Decodable {
    enum CodingKeys: String, CodingKey {
        case total      = "total"
        case skip       = "skip"
        case limit      = "limit"
        case todos      = "todos"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.total = try container.decode(Int64.self, forKey: .total)
        self.skip = try container.decode(Int64.self, forKey: .skip)
        self.limit = try container.decode(Int64.self, forKey: .limit)
        self.todos = try container.decode([TodoResponseDto].self, forKey: .todos)
    }
}
