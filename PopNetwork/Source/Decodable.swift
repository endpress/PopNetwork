//
//  Decodable.swift
//  PopNetwork
//
//  Created by Snow on 2016/12/7.
//  Copyright © 2016年 zsc. All rights reserved.
//

import Foundation

protocol Decodable {
    
    associatedtype Object
    
    static func decode(from request: PopRequest, result: ResultHandler<Object>) -> Void
}
