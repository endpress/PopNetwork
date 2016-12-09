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
    var sessionDelegate: SessionDelegate { get }
}

extension SessionClient {
    
    var session: URLSession {
        return SessionSingleton.default
    }
    
    var sessionDelegate: SessionDelegate {
        return SessionDelegate.default
    }
    
    
    func send<T: PopRequest>(popRequest: T, dataHandler: @escaping DataHandler) {
        
        guard let request = popRequest.urlRequest else { return }
        let task = session.dataTask(with: request)
        sessionDelegate[task] = Response(dataHandler: dataHandler)
        task.resume()
    }
}

struct SessionSingleton {
    static let `default` = URLSession(configuration: .default, delegate: SessionDelegate.default, delegateQueue: nil)
}

struct HTTPClient: SessionClient {
    
}

