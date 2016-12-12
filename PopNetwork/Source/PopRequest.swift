//
//  PopRequest.swift
//  PopNetwork
//
//  Created by apple on 12/7/16.
//  Copyright © 2016 zsc. All rights reserved.
//

import Foundation

/// Types adopting the `URLConvertible` protocol can be used to construct URLs.
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


///protocol used  to construct URLRequest
protocol PopRequest {
    var url: URLConvertiable { get set }
    var method: HTTPMethod { get set }
    var parameter: [String: Any] { get set }
}

