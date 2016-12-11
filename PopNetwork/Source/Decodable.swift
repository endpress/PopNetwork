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
    
//    associatedtype ClientType: Client
    
    static var request: RequestTpye { get }
    
    static func decode<T: PopRequest>(from request: T, result: @escaping ResultHandler<Self>)
    
    static func decode(result: @escaping ResultHandler<Self>)
    
    static func parser(from data: Data) -> Self?
}

extension Decodable {
    
    static func decode(result: @escaping ResultHandler<Self>) {
        decode(from: request, result: result)
    }
    
//    static func defaultClient() -> ClientType {
//        return HTTPClient() as! Self.ClientType
//    }
    
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
