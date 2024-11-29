//
//  NetworkingService.swift
//  EMNetworkingService
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

import Foundation

public final class NetworkingService {
    private let session: URLSession
    private let config: RequestConfiguration
    
    public init(
        sessionConfiguration: URLSessionConfiguration,
        requestConfiguration: RequestConfiguration
    ) {
        session = URLSession(configuration: sessionConfiguration)
        config = requestConfiguration
    }
}
    

extension NetworkingService: NetworkingServiceProtocol {
    public func sendRequestWithRetries<T1: Encodable, T2: Decodable>(
        endpoint: EndpointProtocol,
        requestDto: T1,
        responseDtoType: T2.Type,
        completion: @escaping (Result<T2, NetworkingServiceError>) -> Void
    ) {
        var currentRetry = 0
        var lastError: NetworkingServiceError?
        let operationQueue = OperationQueue()
        
        let operation = BlockOperation()
        operation.addExecutionBlock { [weak self] in
            guard let self else { return }
            
            while currentRetry < config.maxRetries {
                if operation.isCancelled {
                    return completion(.failure(.taskCanceled))
                }
                
                sendRequest(
                    endpoint: endpoint,
                    requestDto: requestDto,
                    responseDtoType: responseDtoType
                ) { [weak self] result in
                    guard let self else {
                        return completion(.failure(.taskCanceled))
                    }
                    
                    switch result {
                        case .success(let response):
                            return completion(.success(response))
                            
                        case .failure(let error):
                            lastError = error
                            
                            if !shouldRetry(for: error) {
                                return completion(.failure(error))
                            }
                    }
                    
                    currentRetry += 1
                    let delayTime = config.delay * pow(2.0, Double(currentRetry - 1))
                    
                    DispatchQueue.global().asyncAfter(deadline: .now() + delayTime) { [weak operation] in
                        guard let operation = operation else { return }
                        
                        if !operation.isCancelled {
                            operationQueue.addOperation(operation)
                        }
                    }
                }
            }
            
            completion(.failure(lastError ?? .unknown))
        }
        
        operationQueue.addOperation(operation)
    }


    public func sendRequest<T1: Encodable, T2: Decodable>(
        endpoint: EndpointProtocol,
        requestDto: T1,
        responseDtoType: T2.Type,
        completion: @escaping (Result<T2, NetworkingServiceError>) -> Void
    ) {
        let urlRequest: URLRequest
        
        do {
            urlRequest = try createRequest(endpoint: endpoint, requestDto: requestDto)
        } catch let error as EncodingError {
            return completion(.failure(.sendRequestEncodingError(endpoint: endpoint, error: error)))
        } catch {
            return completion(.failure(.unknown))
        }
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self else {
                return completion(.failure(.taskCanceled))
            }
            
            let task = session.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    if let urlError = error as? URLError {
                        return completion(.failure(.sendRequestUrlError(urlRequest: urlRequest, error: urlError)))
                    } else {
                        return completion(.failure(.sendRequestUnhandled(urlRequest: urlRequest, error: error)))
                    }
                }
                
                guard let data = data else {
                    return completion(.failure(.sendRequestResponseDataIsNil(urlRequest: urlRequest)))
                }
                
                do {
                    let result = try JSONDecoder().decode(T2.self, from: data)
                    completion(.success(result))
                } catch let error as DecodingError {
                    completion(.failure(.sendRequestDecodingError(urlRequest: urlRequest, error: error)))
                } catch {
                    completion(.failure(.sendRequestUnhandled(urlRequest: urlRequest, error: error)))
                }
            }
            
            task.resume()
        }
        
        DispatchQueue.global().async(execute: workItem)
        
        if workItem.isCancelled {
            return completion(.failure(.taskCanceled))
        }
    }
    
    
    public func fetchDataWithRetries<T: Decodable>(
        url: URL,
        responseDtoType: T.Type,
        completion: @escaping (Result<T, NetworkingServiceError>) -> Void
    ) {
        var currentRetry = 0
        var lastError: NetworkingServiceError?
        let operationQueue = OperationQueue()
        
        let operation = BlockOperation()
        operation.addExecutionBlock { [weak self] in
            guard let self else { return }
            
            while currentRetry < config.maxRetries {
                if operation.isCancelled {
                    return completion(.failure(.taskCanceled))
                }
                
                fetchData(url: url, responseDtoType: responseDtoType) { [weak self] result in
                    guard let self else {
                        return completion(.failure(.taskCanceled))
                    }
                    
                    switch result {
                        case .success(let response):
                            return completion(.success(response))
                            
                        case .failure(let error):
                            lastError = error
                            
                            if !shouldRetry(for: error) {
                                return completion(.failure(error))
                            }
                    }
                    
                    currentRetry += 1
                    let delayTime = config.delay * pow(2.0, Double(currentRetry - 1))
                    
                    DispatchQueue.global().asyncAfter(deadline: .now() + delayTime) {
                        if !operation.isCancelled {
                            operationQueue.addOperation(operation)
                        }
                    }
                }
            }
            
            completion(.failure(lastError ?? .unknown))
        }
        
        operationQueue.addOperation(operation)
    }
    
    
    public func fetchData<T: Decodable>(
        url: URL,
        responseDtoType: T.Type,
        completion: @escaping (Result<T, NetworkingServiceError>) -> Void
    ) {
        let workItem = DispatchWorkItem { [weak self] in
            guard let self else {
                return completion(.failure(.taskCanceled))
            }
            
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    if let urlError = error as? URLError {
                        return completion(.failure(.fetchDataUrlError(url: url, error: urlError)))
                    } else {
                        return completion(.failure(.fetchDataUnhandled(url: url, error: error)))
                    }
                }
                
                guard let data = data else {
                    return completion(.failure(.fetchDataResponseDataIsNil(url: url)))
                }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                } catch let error as DecodingError {
                    completion(.failure(.fetchDataDecodingError(url: url, error: error)))
                } catch {
                    completion(.failure(.fetchDataUnhandled(url: url, error: error)))
                }
            }
            
            task.resume()
        }
        
        DispatchQueue.global().async(execute: workItem)
        if workItem.isCancelled {
            return completion(.failure(.taskCanceled))
        }
    }
    
    
    private func shouldRetry(for error: NetworkingServiceError) -> Bool {
        switch error {
            case .fetchDataUnhandled(_, _), .fetchDataUrlError(_, _),
                    .sendRequestUnhandled(_, _), .sendRequestUrlError(_, _):
                return true
            
            default:
                return false
        }
    }
}
