//
//  PopResponse.swift
//  PopNetwork
//
//  Created by apple on 12/8/16.
//  Copyright © 2016 zsc. All rights reserved.
//

import Foundation


protocol PopResponse {
    /// The server's response
    var response: HTTPURLResponse? { get }
    
    /// The data returned by the server.
    var data: Data? { get }
    
    /// The dataHandler
    var dataHandler: DataHandler? { get }
}

struct Response: PopResponse {
    
    var response: HTTPURLResponse?
    var data: Data? = Data()
    var dataHandler: DataHandler?
    
    init(dataHandler: DataHandler? = nil) {
        self.dataHandler = dataHandler
    }
}
