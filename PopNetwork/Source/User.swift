//
//  User.swift
//  PopNetwork
//
//  Created by apple on 12/8/16.
//  Copyright © 2016 zsc. All rights reserved.
//

import Foundation


struct User: Decodable {
    let name: String
    let message: String
    
    typealias Object = User
    
    static func decode(from request: PopRequest, result: ResultHandler<User>) {
        result(Result.Faliure(error: PopError.error(reason: "hahaha")))
    }
}
