import ArgumentParser

struct SkewRatio: ExpressibleByArgument, ExpressibleByFloatLiteral {
    let rawValue: Double

    static let range: ClosedRange<Double> = 0...1

    init(floatLiteral: Double) {
        self.rawValue = floatLiteral
    }

    init?(argument: String) {
        if let value = Double(argument), Self.range ~= value {
            rawValue = value
        } else {
            return nil
        }
    }

    var int16: Int16 {
        Int16(
            (Double(rawValue) - Double(Self.range.size)/2)
            * (Double(Int16.max) - Double(Int16.min)))
    }
}
