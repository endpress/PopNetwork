//
//  SessionHttpClient.swift
//  PopNetwork
//
//  Created by apple on 12/7/16.
//  Copyright © 2016 zsc. All rights reserved.
//

import Foundation

protocol Client {
    func send<T: PopRequest>(popRequest: T)
}


protocol SessionClient: Client {
    var session: URLSession { get }
}

extension SessionClient {
    var session: URLSession {
        return URLSession.shared
    }
    
    func send<T: PopRequest>(popRequest: T) {
        
        guard let url = popRequest.url.asURL() else { return }
        var request = URLRequest(url: url)
        request.httpMethod = popRequest.method.rawValue
        
        let task = session.dataTask(with: request)
        task.resume()
    }
}

