import ArgumentParser

struct Angle: ExpressibleByArgument {
    let rawValue: Int

    static let range = 0...360

    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    init(uint16: UInt16) {
        self.rawValue = Self.range.lowerBound
            + Int((Double(uint16) / Double(UInt16.max) * Double(Self.range.size)).rounded())
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
