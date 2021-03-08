//
//  Data.swift
//  
//
//  Created by Gareth Redman on 8/03/21.
//

import Foundation

extension Data {
    init<First, Second>(_ first: First, _ second: Second) {
        var contentBytes = [UInt8]()
        var first = first
        var second = second

        Swift.withUnsafeBytes(of: &first) { bytes in
            contentBytes.append(contentsOf: bytes)
        }
        Swift.withUnsafeBytes(of: &second) { bytes in
            contentBytes.append(contentsOf: bytes)
        }
        self = Data(bytes: contentBytes, count: contentBytes.count)
    }
}
