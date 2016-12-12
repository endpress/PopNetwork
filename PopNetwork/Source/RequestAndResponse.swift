//
//  RequestAndResponse.swift
//  PopNetwork
//
//  Created by Snow on 2016/12/11.
//  Copyright © 2016年 zsc. All rights reserved.
//

import Foundation


/// Just a case. You can user anything else that confirms PopRequest
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

/// Just a case. You can user anything else that confirms PopResponse
struct Response: PopResponse {
    
    var response: HTTPURLResponse?
    var data: Data? = Data()
    var dataHandler: DataHandler?
    
    init(dataHandler: DataHandler? = nil) {
        self.dataHandler = dataHandler
    }
}

/// Just a case. You can user anything else that confirms SessionClient
struct HTTPClient: SessionClient {
    
}

/// Just a case. You can user anything else that confirms ParameterEncoding
struct ParameterEncoder: ParameterEncoding {
    
}
