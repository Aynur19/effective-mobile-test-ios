//
//  NetworkingServiceError.swift
//  EMNetworkingService
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

import Foundation
import EMCore

public enum NetworkingServiceError {
    case taskCanceled
    
    case sendRequestEncodingError(endpoint: EndpointProtocol, error: EncodingError)
    case sendRequestUrlError(endpoint: EndpointProtocol, error: URLError)
    case sendRequestNotHttpResponse(request: URLRequest, response: URLResponse, data: Data)
    case sendRequestHttpResponseHasNotStatus2xx(request: URLRequest, response: HTTPURLResponse, data: Data)
    case sendRequestDecodingError(endpoint: EndpointProtocol, error: DecodingError)
    case sendRequestUnhandled(endpoint: EndpointProtocol, error: Error)
    
    case fetchDataUrlError(url: URL, error: URLError)
    case fetchDataDecodingError(url: URL, error: DecodingError)
    case fetchDataUnhandled(url: URL, error: Error)
    
    case unknown
}

extension NetworkingServiceError: AppErrorProtocol {
    public var debugMessage: String {
        return switch self {
            case .taskCanceled:
                "Запрос был отменен сервисом более верхнего уровня\n"
                
            case .sendRequestEncodingError(let endpoint, let error):
                "Ошибка преобразования модели DTO в тело запроса (body):\n" +
                "   Endpoint: \(endpoint)\n" +
                "   Error: \(error)\n"
                
            case .sendRequestUrlError(endpoint: let endpoint, error: let error):
                "Сетевая ошибка при выполнении запроса:\n" +
                "   Endpoint: \(endpoint)\n" +
                "   Error: \(error)\n"
                
            case .sendRequestNotHttpResponse(let request, let response, let data):
                "Не удалось привести объект типа URLResponse к типу HTTPURLResponse:\n" +
                "   URLRequest: \(String(describing: request))\n" +
                "   URLResponse: \(response)\n" +
                "   Data (Str): \(String(data: data, encoding: .utf8) ?? "nil (UTF-8)")\n"
                
            case .sendRequestHttpResponseHasNotStatus2xx(let request, let response, let data):
                "Ответ за запрос вернул HTTP статус с кодом не равным 2ХХ:\n" +
                "   URLRequest: \(String(describing: request))\n" +
                "   HTTPURLResponse: \(response)\n" +
                "   Data (Str): \(String(data: data, encoding: .utf8) ?? "nil (UTF-8)")\n"
                
            case .sendRequestDecodingError(let endpoint, let error):
                "Не удалось преобразовать тело ответа в DTO модель ответа:\n" +
                "   Endpoint: \(endpoint)\n" +
                "   Error: \(error)\n"
                
            case .sendRequestUnhandled(let endpoint, let error):
                "Необработанная ошибка при выполнении сетевого запроса:\n" +
                "   Endpoint: \(endpoint)\n" +
                "   Error: \(error)\n"
                
                
            case .fetchDataUrlError(let url, let error):
                "Сетевая ошибка при выполнении запроса:\n" +
                "   URL: \(url)\n" +
                "   Error: \(error)\n"
                
            case .fetchDataDecodingError(let url, let error):
                "Не удалось преобразовать тело ответа в DTO модель ответа:\n" +
                "   URL: \(url)\n" +
                "   Error: \(error)\n"
                
            case .fetchDataUnhandled(let url, let error):
                "Необработанная ошибка при выполнении сетевого запроса:\n" +
                "   URL: \(url)\n" +
                "   Error: \(error)\n"
                
            case .unknown:
                "НЕИЗВЕСТНАЯ ОШИБКА...\n"
        }
    }
}
