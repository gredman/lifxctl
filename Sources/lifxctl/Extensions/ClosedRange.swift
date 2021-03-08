//
//  ClosedRange.swift
//  
//
//  Created by Gareth Redman on 8/03/21.
//

import Foundation

extension ClosedRange where Bound: Numeric {
    var size: Bound {
        upperBound - lowerBound
    }
}
