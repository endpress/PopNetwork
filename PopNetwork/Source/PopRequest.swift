//
//  PopRequest.swift
//  PopNetwork
//
//  Created by apple on 12/7/16.
//  Copyright © 2016 zsc. All rights reserved.
//

import Foundation

protocol PopRequest {
    var urlString: String { get set }
    var method: HTTPMethod { get set }
    var parameter: [String: Any] { get set }
}

protocol SessionRequest {
    
}
