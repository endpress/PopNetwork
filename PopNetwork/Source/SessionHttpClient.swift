//
//  SessionHttpClient.swift
//  PopNetwork
//
//  Created by apple on 12/7/16.
//  Copyright © 2016 zsc. All rights reserved.
//

import Foundation

protocol Client {
    
}

extension URLSession {
    static let instance = URLSession(configuration: .default)
}

struct SessionHttpClient {
    
    let session: URLSession
    
}
