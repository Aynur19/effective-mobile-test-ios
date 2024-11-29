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
    case sendRequestUrlError(urlRequest: URLRequest, error: URLError)
    case sendRequestNotHttpResponse(urlRequest: URLRequest, response: URLResponse)
    case sendRequestHttpResponseHasNotStatus2xx(urlRequest: URLRequest, response: HTTPURLResponse)
    case sendRequestDecodingError(urlRequest: URLRequest, error: DecodingError)
    case sendRequestUnhandled(urlRequest: URLRequest, error: Error)
    case sendRequestResponseDataIsNil(urlRequest: URLRequest)
    
    case fetchDataUrlError(url: URL, error: URLError)
    case fetchDataDecodingError(url: URL, error: DecodingError)
    case fetchDataUnhandled(url: URL, error: Error)
    case fetchDataResponseDataIsNil(url: URL)
    
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
                
            case .sendRequestUrlError(let urlRequest, let error):
                "Сетевая ошибка при выполнении запроса:\n" +
                "   URLRequest: \(urlRequest)\n" +
                "   Error: \(error)\n"
                
            case .sendRequestNotHttpResponse(let urlRequest, let response):
                "Не удалось привести объект типа URLResponse к типу HTTPURLResponse:\n" +
                "   URLRequest: \(String(describing: urlRequest))\n" +
                "   URLResponse: \(response)\n"
                
            case .sendRequestHttpResponseHasNotStatus2xx(let urlRequest, let response):
                "Ответ за запрос вернул HTTP статус с кодом не равным 2ХХ:\n" +
                "   URLRequest: \(String(describing: urlRequest))\n" +
                "   HTTPURLResponse: \(response)\n"
                
            case .sendRequestDecodingError(let urlRequest, let error):
                "Не удалось преобразовать тело ответа в DTO модель ответа:\n" +
                "   URLRequest: \(urlRequest)\n" +
                "   Error: \(error)\n"
                
            case .sendRequestUnhandled(let urlRequest, let error):
                "Необработанная ошибка при выполнении сетевого запроса:\n" +
                "   URLRequest: \(urlRequest)\n" +
                "   Error: \(error)\n"
                
            case .sendRequestResponseDataIsNil(let urlRequest):
                "Получены пустые данные (data == nil):\n" +
                "   URLRequest: \(urlRequest)\n"
                
                
                
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
                
            case .fetchDataResponseDataIsNil(let url):
                "Получены пустые данные (data == nil):\n" +
                "   URL: \(url)\n"
                
            case .unknown:
                "НЕИЗВЕСТНАЯ ОШИБКА...\n"
        }
    }
}
