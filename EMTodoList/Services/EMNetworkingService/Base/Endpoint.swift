//
//  Endpoint.swift
//  EMNetworkingService
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

import Foundation

public protocol EndpointProtocol {
    var url: URL { get }
    var method: RequestMethod { get }
    var header: [String : String]? { get }
    
    static func create(urlString: String, method: RequestMethod, parameters: [String:String]?) -> EndpointProtocol?
}


public struct Endpoint: EndpointProtocol {
    public let url: URL
    public let method: RequestMethod
    public let header: [String : String]?
    
    public static func create(
        urlString: String,
        method: RequestMethod = .post,
        parameters: [String:String]? = nil
    ) -> EndpointProtocol? {
        guard var components = URLComponents(string: urlString) else { return nil }

        if let parameters = parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let finalURL = components.url else { return nil }

        return Endpoint(url: finalURL, method: method, header: nil)
    }
}
