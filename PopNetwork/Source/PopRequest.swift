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
    var urlRequest: URLRequest? { get }
}

extension PopRequest {
    var urlRequest: URLRequest? {
        guard let url = url.asURL() else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}

