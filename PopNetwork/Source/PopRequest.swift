//
//  PopRequest.swift
//  PopNetwork
//
//  Created by apple on 12/7/16.
//  Copyright © 2016 zsc. All rights reserved.
//

import Foundation


protocol URLConvertiable {
    func asURL() -> URL?
}

extension String: URLConvertiable {
    func asURL() -> URL? {
        return URL(string: self)
    }
}

extension URL: URLConvertiable {
    func asURL() -> URL? {
        return self
    }
}

protocol PopRequest {
    var url: URLConvertiable { get set }
    var method: HTTPMethod { get set }
    var parameter: [String: Any] { get set }
}

struct Request: PopRequest {
    var url: URLConvertiable
    var method: HTTPMethod
    var parameter: Parameters
    
    init(url: URLConvertiable, parameter: Parameters = [:], method: HTTPMethod = .GET) {
        self.url = url
        self.parameter = parameter
        self.method = method
    }
}
