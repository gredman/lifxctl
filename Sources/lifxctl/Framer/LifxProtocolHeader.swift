//
//  LifxProtocolHeader.swift
//  
//
//  Created by Gareth Redman on 7/03/21.
//

import Foundation

struct LifxProtocolHeader {
    let type: UInt16

    static let getService = LifxProtocolHeader(type: 2)
    static let setPower = LifxProtocolHeader(type: 117)
}
