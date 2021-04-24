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
        } else if let angle = Self(name: argument) {
            self = angle
        } else {
            return nil
        }
    }

    private init?(name: String) {
        switch name {
        case "red":
            rawValue = 0
        case "yellow":
            rawValue = 45
        case "green":
            rawValue = 120
        case "blue":
            rawValue = 180
        case "purple":
            rawValue = 225
        case "pink":
            rawValue = 315
        default:
            return nil
        }
    }

    var uint16: UInt16 {
        UInt16(Int(UInt16.max) * rawValue / Self.range.size)
    }
}
