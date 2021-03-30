import Foundation

struct LifxFrameAddress {
    private static var sequence: UInt8 = 0

    let target: Target

    let responseRequired: Bool

    let acknowledgementRequired: Bool

    let sequence: UInt8
    
    private static func nextSequence() -> UInt8 {
        defer { LifxFrameAddress.sequence += 1 }
        return LifxFrameAddress.sequence
    }
    
    init(target: Target = .zero, responseRequired: Bool = false, acknowledgementRequired: Bool = false, sequence: UInt8 = Self.nextSequence()) {
        self.target = target
        self.responseRequired = responseRequired
        self.acknowledgementRequired = acknowledgementRequired
        self.sequence = sequence
    }
    
    struct Target {
        let byte0: UInt8
        let byte1: UInt8
        let byte2: UInt8
        let byte3: UInt8
        let byte4: UInt8
        let byte5: UInt8
        let byte6: UInt8
        let byte7: UInt8

        static let zero = Target(byte0: 0, byte1: 0, byte2: 0, byte3: 0, byte4: 0, byte5: 0, byte6: 0, byte7: 0)
    }
}
