import ArgumentParser

struct Temperature: ExpressibleByArgument, CustomStringConvertible {
    let rawValue: Int

    static let range = 2500...9000

    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    init(uint16: UInt16) {
        self.rawValue = Int(uint16)
    }

    init?(argument: String) {
        if let value = Int(argument), Self.range ~= value {
            rawValue = value
        } else {
            return nil
        }
    }

    var uint16: UInt16 {
        UInt16(rawValue)
    }

    var description: String {
        String(rawValue) + "K"
    }
}
