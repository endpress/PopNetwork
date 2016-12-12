//
//  Utils.swift
//  PopNetwork
//
//  Created by apple on 12/7/16.
//  Copyright © 2016 zsc. All rights reserved.
//

import Foundation

/// HTTP method definitions.
enum HTTPMethod: String {
    case GET
    case POST
}

/// A common result
enum Result<T> {
    case Success(result: T)
    case Faliure(error: PopError)
}

// MARK: - Typealias
/// A dictionary of parameters to apply to a `URLRequest`.
typealias Parameters = [String: Any]
/// A closure to handle the final result
typealias ResultHandler<T> = (Result<T>) -> Void
/// A closure to parse data retruned from `DataTask`.
typealias DataHandler = (Result<Data>) -> Void



