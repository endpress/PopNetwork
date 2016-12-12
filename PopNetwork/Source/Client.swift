//
//  SessionHttpClient.swift
//  PopNetwork
//
//  Created by apple on 12/7/16.
//  Copyright © 2016 zsc. All rights reserved.
//

import Foundation

/// the client protocol used to sent request and handle data
protocol Client {
    func send<T: PopRequest>(popRequest: T, dataHandler: @escaping DataHandler)
}

/// a session client use session to sent request
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
        let parameterEncoder = ParameterEncoder()
        let encodeError = PopError.error(reason: "ParameterEncoder encode function failed")
        guard let request = parameterEncoder.encode(popRequest: popRequest) else {
            return dataHandler(Result.Faliure(error: encodeError))
        }
        let task = session.dataTask(with: request)
        sessionDelegate[task] = Response(dataHandler: dataHandler)
        task.resume()
    }
}

struct SessionSingleton {
    static let `default` = URLSession(configuration: .default, delegate: SessionDelegate.default, delegateQueue: nil)
}


