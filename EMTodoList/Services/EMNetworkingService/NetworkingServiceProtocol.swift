//
//  NetworkingServiceProtocol.swift
//  EMNetworkingService
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

import Foundation

public protocol NetworkingServiceProtocol {
    func sendRequestWithRetries<T1: Encodable, T2: Decodable>(
        endpoint: EndpointProtocol,
        requestDto: T1,
        responseDtoType: T2.Type,
        completion: @escaping (Result<T2, NetworkingServiceError>) -> Void
    )
    
    func sendRequest<T1: Encodable, T2: Decodable>(
        endpoint: EndpointProtocol,
        requestDto: T1,
        responseDtoType: T2.Type,
        completion: @escaping (Result<T2, NetworkingServiceError>) -> Void
    )
    
    func fetchDataWithRetries<T: Decodable>(
        url: URL,
        responseDtoType: T.Type,
        completion: @escaping (Result<T, NetworkingServiceError>) -> Void
    )
    
    func fetchData<T: Decodable>(
        url: URL,
        responseDtoType: T.Type,
        completion: @escaping (Result<T, NetworkingServiceError>) -> Void
    )
}


extension NetworkingServiceProtocol {
    public func createRequest<T: Encodable>(endpoint: EndpointProtocol, requestDto: T) throws -> URLRequest {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        request.httpBody = try getRequestBody(endpoint: endpoint, requestDto: requestDto)
        
        return request
    }
    
    private func getRequestBody<T: Encodable>(endpoint: EndpointProtocol, requestDto: T) throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        
        return try encoder.encode(requestDto)
    }
}
