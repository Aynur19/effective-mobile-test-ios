//
//  TodoResponseDto.swift
//  EMTodoApiService
//
//  Created by Aynur Nasybullin on 29.11.2024.
//

public struct TodoResponseDto {
    public let id: Int64
    public let todo: String
    public let completed: Bool
    public let userId: Int64
}

extension TodoResponseDto: Decodable {
    enum CodingKeys: String, CodingKey {
        case id         = "log"
        case todo       = "todo"
        case completed  = "completed"
        case userId     = "userId"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int64.self, forKey: .id)
        self.todo = try container.decode(String.self, forKey: .todo)
        self.completed = try container.decode(Bool.self, forKey: .completed)
        self.userId = try container.decode(Int64.self, forKey: .userId)
    }
}
