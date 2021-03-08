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
        contentBytes.appendBytes(of: first)
        contentBytes.appendBytes(of: second)
        self = Data(bytes: contentBytes, count: contentBytes.count)
    }

    init<First, Second, Third, Fourth, Fifth, Sixth>(_ first: First, _ second: Second, _ third: Third, _ fourth: Fourth, _ fifth: Fifth, _ sixth: Sixth) {
        var contentBytes = [UInt8]()
        contentBytes.appendBytes(of: first)
        contentBytes.appendBytes(of: second)
        contentBytes.appendBytes(of: third)
        contentBytes.appendBytes(of: fourth)
        contentBytes.appendBytes(of: fifth)
        contentBytes.appendBytes(of: sixth)
        self = Data(bytes: contentBytes, count: contentBytes.count)
    }
}

private extension Array where Element == UInt8 {
    mutating func appendBytes<T>(of value: T) {
        var value = value
        Swift.withUnsafeBytes(of: &value) { bytes in
            append(contentsOf: bytes)
        }
    }
}
