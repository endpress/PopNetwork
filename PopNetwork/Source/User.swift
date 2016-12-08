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
    
    static func decode<T: PopRequest>(from request: T, result: @escaping ResultHandler<User>) {
        let client = HTTPClient()
        client.send(popRequest: request) {data, error in
            if let data = data, let dic = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                print("\(dic)")
                guard let dic = dic as? Dictionary<String, String> else { return }
                guard let name = dic["name"], let message = dic["message"] else { result(Result.Faliure(error: PopError.error(reason: "haha"))); return }
                let user = User(name: name, message: message)
                result(Result.Success(result: user))
            }
        }
    }
}
