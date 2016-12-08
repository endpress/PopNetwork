//
//  SessionHttpClient.swift
//  PopNetwork
//
//  Created by apple on 12/7/16.
//  Copyright © 2016 zsc. All rights reserved.
//

import Foundation

protocol Client {
    func send<T: PopRequest>(popRequest: T, dataHandler: @escaping DataHandler)
}


protocol SessionClient: Client {
    var session: URLSession { get }
}

extension SessionClient {
    var session: URLSession {
        return SessionSingleton.default
    }
    
    func send<T: PopRequest>(popRequest: T, dataHandler: @escaping DataHandler) {
        
        guard let url = popRequest.url.asURL() else { return }
        var request = URLRequest(url: url)
        request.httpMethod = popRequest.method.rawValue
        
        let task = session.dataTask(with: request)
        let sessionDelegate = SessionDelegate.default
        var response = Response()
        response.dataHandler = dataHandler
        sessionDelegate[task] = response
        task.resume()
    }
}

struct HTTPClient: SessionClient {
}

struct SessionSingleton {
    static let `default` = URLSession(configuration: .default, delegate: SessionDelegate.default, delegateQueue: nil)
}

