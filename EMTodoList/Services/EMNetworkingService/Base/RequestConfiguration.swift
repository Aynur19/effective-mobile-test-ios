//
//  RequestConfiguration.swift
//  EMNetworkingService
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

public struct RequestConfiguration {
    public let maxRetries: Int
    public let delay: Double
    
    public init(
        maxRetries: Int,
        firstDelay: Double
    ) {
        self.maxRetries = maxRetries
        self.delay = firstDelay
    }
}
