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
    
    /// you can use anything that confirms PopRequest protocol instead Request
    typealias RequestType = Request
    
    static var request: RequestType {
        return Request(url: "https://api.onevcat.com/users/onevcat")
    }
    
    static func parser(from data: Data) -> User? {
        if let dic = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
            guard let dic = dic as? Dictionary<String, String> else { return nil }
            guard let name = dic["name"], let message = dic["message"] else { return nil }
            let user = User(name: name, message: message)
            return user
        }
        return nil
    }
}

extension User: CustomStringConvertible {
    var description: String {
        return "name is \(name), message is \(message)"
    }
}
