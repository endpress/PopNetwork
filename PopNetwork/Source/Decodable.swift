//
//  Decodable.swift
//  PopNetwork
//
//  Created by Snow on 2016/12/7.
//  Copyright © 2016年 zsc. All rights reserved.
//

import Foundation

protocol URLable {
    func asURL() -> URL?
}

protocol Decodable {
    func decode(from url: String) -> Self
    func decode(from url: URL) -> Self
    func decode(from url: NSURL) -> Self
}
