//
//  NetworkResponseErrorProtocol.swift
//  EMNetworkingService
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

import EMCore

public protocol NetworkResponseErrorProtocol {
    associatedtype ErrorType: AppErrorProtocol
    
    var isSuccess: Bool { get }
    
    var error: ErrorType? { get }
}
