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

    let `protocol`: UInt16 = 1024

    let addressable = true

    var tagged = false

    let origin = 0

    let source: UInt32 = LifxFrame.source
}
