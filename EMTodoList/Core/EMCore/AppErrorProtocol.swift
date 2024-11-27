//
//  AppErrorProtocol.swift
//  EMCore
//
//  Created by Aynur Nasybullin on 27.11.2024.
//

public protocol AppErrorProtocol: Error {
    var debugMessage: String { get }
}
