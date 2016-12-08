//
//  Utils.swift
//  PopNetwork
//
//  Created by apple on 12/7/16.
//  Copyright © 2016 zsc. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

typealias Parameters = [String: Any]
typealias ResultHandler<T> = (Result<T>) -> Void

enum Result<T> {
    case Success(result: T)
    case Faliure(error: PopError)
}


