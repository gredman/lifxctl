import Foundation

extension ClosedRange where Bound: Numeric {
    var size: Bound {
        upperBound - lowerBound
    }
}
