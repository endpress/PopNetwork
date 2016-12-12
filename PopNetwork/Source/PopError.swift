//
//  Error.swift
//  PopNetwork
//
//  Created by apple on 12/7/16.
//  Copyright © 2016 zsc. All rights reserved.
//

import Foundation

/// `PopError` is the error type returned by PopNetwork. It encompasses a few different types of errors, each with
/// their own associated reasons.
///

public enum PopError: Error {
    case error(reason: String)
}
