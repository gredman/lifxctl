import Foundation

struct LifxProtocolHeader {
    let type: UInt16

    static let getService = LifxProtocolHeader(type: 2)
    static let get = LifxProtocolHeader(type: 101)
    static let setColor = LifxProtocolHeader(type: 102)
    static let setPower = LifxProtocolHeader(type: 117)
}
