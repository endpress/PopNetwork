//
//  RequestAndResponse.swift
//  PopNetwork
//
//  Created by Snow on 2016/12/11.
//  Copyright © 2016年 zsc. All rights reserved.
//

import Foundation



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


struct Response: PopResponse {
    
    var response: HTTPURLResponse?
    var data: Data? = Data()
    var dataHandler: DataHandler?
    
    init(dataHandler: DataHandler? = nil) {
        self.dataHandler = dataHandler
    }
}
