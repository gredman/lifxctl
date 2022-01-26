import ArgumentParser

enum Waveform: String, ExpressibleByArgument, CaseIterable {
    case saw
    case sine
    case halfSine
    case triangle
    case pulse

    var uint8: UInt8 {
        switch self {
        case .saw: return 0
        case .sine: return 1
        case .halfSine: return 2
        case .triangle: return 3
        case .pulse: return 4
        }
    }

    static var allValueStrings: [String] {
        allCases.map(\.rawValue)
    }
}
