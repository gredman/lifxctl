//
//  Data.swift
//  
//
//  Created by Gareth Redman on 8/03/21.
//

import Foundation

extension Data {
    mutating func appendBytes<T>(of value: T) {
        var value = value
        Swift.withUnsafeBytes(of: &value) { bytes in
            append(contentsOf: bytes)
        }
    }
}
