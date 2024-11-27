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
        responseDtoType: T2.Type
    ) async -> Result<T2, NetworkingServiceError> {
        var currentRetry = 0
        var lastError: NetworkingServiceError?

        while currentRetry < config.maxRetries {
            if Task.isCancelled {
                return .failure(.taskCanceled)
            }

            let result = await sendRequest(
                endpoint: endpoint,
                requestDto: requestDto,
                responseDtoType: responseDtoType
            )
            
            switch result {
                case .success(let response):
                    return .success(response)
                    
                case .failure(let error):
                    lastError = error
                    
                    if !shouldRetry(for: error) {
                        return .failure(error)
                    }
            }
            currentRetry += 1

            // Экспоненциальная задержка
            print("Ошибка при выполненнии запроса. lastError: \(lastError?.debugMessage ?? "nil")")
            let delayTime = config.delay * pow(2.0, Double(currentRetry - 1))
            try? await Task.sleep(nanoseconds: UInt64(delayTime * 1_000_000_000))
        }
        
        // Если все попытки были неудачны, возвращаем последнюю ошибку
        return .failure(lastError ?? .unknown)
    }


    public func sendRequest<T1: Encodable, T2: Decodable>(
        endpoint: EndpointProtocol,
        requestDto: T1,
        responseDtoType: T2.Type
    ) async -> Result<T2, NetworkingServiceError> {
        do {
            let urlRequest = try createRequest(endpoint: endpoint, requestDto: requestDto)
            let (data, response) = try await session.data(for: urlRequest)
            try checkResponse(request: urlRequest, response: response, data: data)
            let responseDto = try JSONDecoder().decode(T2.self, from: data)
            return .success(responseDto)
        } catch let error as NetworkingServiceError {
            return .failure(error)
        } catch let error as URLError {
            return .failure(.sendRequestUrlError(endpoint: endpoint, error: error))
        } catch let error as DecodingError {
            return .failure(.sendRequestDecodingError(endpoint: endpoint, error: error))
        } catch {
            return .failure(.sendRequestUnhandled(endpoint: endpoint, error: error))
        }
    }
    
    
    public func fetchDataWithRetries<T: Decodable>(
        url: URL,
        type: T.Type
    ) async -> Result<T, NetworkingServiceError> {
        var currentRetry = 0
        var lastError: NetworkingServiceError?

        while currentRetry < config.maxRetries {
            if Task.isCancelled {
                return .failure(.taskCanceled)
            }

            let result = await fetchData(url: url, type: type)
            
            switch result {
                case .success(let response):
                    return .success(response)
                    
                case .failure(let error):
                    lastError = error
                    
                    if !shouldRetry(for: error) {
                        return .failure(error)
                    }
            }
            currentRetry += 1

            // Экспоненциальная задержка
            let delayTime = config.delay * pow(2.0, Double(currentRetry - 1))
            try? await Task.sleep(nanoseconds: UInt64(delayTime * 1_000_000_000))
        }
        
        return .failure(lastError ?? .unknown)
    }
    
    
    public func fetchData<T: Decodable>(
        url: URL,
        type: T.Type
    ) async -> Result<T, NetworkingServiceError> {
        do {
            let (data, _) = try await session.data(from: url)
            let result = try JSONDecoder().decode(T.self, from: data)
            return .success(result)
        } catch let error as URLError {
            return .failure(.fetchDataUrlError(url: url, error: error))
        } catch let error as DecodingError {
            return .failure(.fetchDataDecodingError(url: url, error: error))
        } catch {
            return .failure(.fetchDataUnhandled(url: url, error: error))
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
    
    
    private func checkResponse(request: URLRequest, response: URLResponse, data: Data) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkingServiceError.sendRequestNotHttpResponse(
                request: request, response: response, data: data
            )
        }
        
        guard 200...299 ~= response.statusCode else {
            throw NetworkingServiceError.sendRequestHttpResponseHasNotStatus2xx(
                request: request, response: response, data: data
            )
        }
    }
}
