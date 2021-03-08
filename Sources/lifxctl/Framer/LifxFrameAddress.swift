//
//  LifxFrameAddress.swift
//  
//
//  Created by Gareth Redman on 7/03/21.
//

import Foundation

struct LifxFrameAddress {
    static var sequence: UInt8 = 0

    var target: UInt64

    var responseRequired = false

    var acknowledgementRequired = false

    let sequence: UInt8 = {
        defer { LifxFrameAddress.sequence += 1 }
        return LifxFrameAddress.sequence
    }()
}
