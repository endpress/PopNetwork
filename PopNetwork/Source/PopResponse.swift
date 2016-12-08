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
    var data: NSMutableData? { get }
    
    /// The error encountered while executing or validating the request.
    var error: Error? { get }
    
    var dataHandler: DataHandler? { get }
}

struct Response: PopResponse {
    
    var response: HTTPURLResponse?
    var data: NSMutableData? = NSMutableData(capacity: 0)
    var error: Error?
    var dataHandler: DataHandler?
    
    init() {
        
    }
}
