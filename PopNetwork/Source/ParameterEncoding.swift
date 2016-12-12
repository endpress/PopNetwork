//
//  ParameterEncoding.swift
//  PopNetwork
//
//  Created by apple on 12/12/16.
//  Copyright © 2016 zsc. All rights reserved.
//

import Foundation

/// A type used to define how a set of parameters are applied to a `URLRequest`.
protocol ParameterEncoding {
    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter popRequest: The request to have parameters applied.
    ///
    /// - returns: The encoded request.
    func encode<T: PopRequest>(popRequest: T) -> URLRequest?
    /// Create a encoding string by query paramter
    func query(_ parameters: Parameters) -> String
    /// Query a component
    func queryComponents(fromKey key: String, value: Any) -> [(String, String)]
}


extension ParameterEncoding {
    func encode<T: PopRequest>(popRequest: T) -> URLRequest? {
        guard let url = popRequest.url.asURL() else { return nil }
        
        var urlRequest = URLRequest(url: url)
        let parameter = popRequest.parameter
        
        switch popRequest.method {
        case .GET:
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameter)
                urlComponents.percentEncodedQuery = percentEncodedQuery
                urlRequest.url = urlComponents.url
            }
        case .POST:
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = query(parameter).data(using: .utf8, allowLossyConversion: false)
        }
        return urlRequest
    }
    
    func query(_ parameters: Parameters) -> String {
        var components = [(String, String)]()
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        return components.map{ "\($0)=\($1)" }.joined(separator: "&")
    }
    
    func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        
        
        func escape(_ string: String) -> String {
            let generalDelimitersToEncode = ":#[]@"
            let subDelimitersToEncode = "!$&'()*+,;="
            
            var allowedCharacterSet = CharacterSet.urlQueryAllowed
            allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
            
            return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        }
        
        var components = [(String, String)]()
        
        if let dictionary = value as? Parameters {
            for (subKey, subValue) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(subKey)]", value: subValue)
            }
        } else if let array = value as? [Any] {
            for subValue in array {
                components += queryComponents(fromKey: "\(key)[]", value: subValue)
            }
        } else {
            components += [(escape(key), escape("\(value)"))]
        }
        
        return components
    }
}
