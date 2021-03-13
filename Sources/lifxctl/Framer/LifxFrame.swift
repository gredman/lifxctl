//
//  LifxFrame.swift
//  
//
//  Created by Gareth Redman on 7/03/21.
//

import Foundation

private var rng = SystemRandomNumberGenerator()

struct LifxFrame {
    static let source: UInt32 = rng.next(upperBound: UInt32.max)

    var `protocol`: UInt16 = 1024

    var addressable = true

    var tagged = false

    var origin: UInt8 = 0

    var source: UInt32 = LifxFrame.source
}
