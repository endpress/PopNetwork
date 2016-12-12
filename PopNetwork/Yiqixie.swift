//
//  Yiqixie.swift
//  PopNetwork
//
//  Created by apple on 12/12/16.
//  Copyright © 2016 zsc. All rights reserved.
//

import Foundation


struct Yiqixie: Decodable {
    let message: String
    
    typealias RequestTpye = Request
    
    static var request: RequestTpye {
        return Request(url: "https://www.baidu.com")
    }
    
    static func parser(from data: Data) -> Yiqixie? {
        if let dic = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
            guard let dic = dic as? Dictionary<String, String> else { return nil }
            print("return string is \(dic)")
            return nil
        }
        return nil
    }
}

extension Yiqixie: CustomStringConvertible {
    var description: String {
        return "message is \(message)"
    }
}
