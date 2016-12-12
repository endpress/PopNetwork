//
//  Decodable.swift
//  PopNetwork
//
//  Created by Snow on 2016/12/7.
//  Copyright © 2016年 zsc. All rights reserved.
//

import Foundation

/// decodable protocol is used to generator a object from network data
protocol Decodable {
    
    /// request that used to sent. It must confirm PopRequest protocol
    associatedtype RequestTpye: PopRequest
    /// the request that construct URLRequest
    static var request: RequestTpye { get }
    /// Decode a object from a request.
    static func decode<T: PopRequest>(from request: T, result: @escaping ResultHandler<Self>)
    /// Decode a object from a request
    static func decode(result: @escaping ResultHandler<Self>)
    /// Parser the data returned by server
    static func parser(from data: Data) -> Self?
}

/// default function. You can your own function instead.
extension Decodable {
    
    static func decode(result: @escaping ResultHandler<Self>) {
        decode(from: request, result: result)
    }
    
    static func decode<T: PopRequest>(from request: T, result: @escaping ResultHandler<Self>) {
        
        let parserError = PopError.error(reason: "parser function return nil")
        
        HTTPClient().send(popRequest: request) { dataResult in
            switch dataResult {
            case .Success(let data):
                guard let object = parser(from: data) else {
                    result(Result.Faliure(error: parserError))
                    return
                }
                result(Result.Success(result: object))
            case .Faliure(let error):
                result(Result.Faliure(error: error))
            }
        }
    }
}
