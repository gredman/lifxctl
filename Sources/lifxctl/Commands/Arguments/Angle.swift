//
//  Angle.swift
//  
//
//  Created by Gareth Redman on 8/03/21.
//

import ArgumentParser

struct Angle: ExpressibleByArgument {
    let rawValue: Int

    static let range = 0...360

    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    init?(argument: String) {
        if let value = Int(argument), Self.range ~= value {
            rawValue = value
        } else {
            return nil
        }
    }

    var uint16: UInt16 {
        UInt16(Int(UInt16.max) * rawValue / Self.range.size)
    }
}
