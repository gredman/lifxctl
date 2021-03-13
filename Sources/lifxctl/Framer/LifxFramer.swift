//
//  Framer.swift
//  
//
//  Created by Gareth Redman on 7/03/21.
//

import Foundation
import Network
import os

private let logger = Logger(category: "LifxFramer")

class LifxFramer: NWProtocolFramerImplementation {
    static let label = "Lifx"

    static let definition = NWProtocolFramer.Definition(implementation: LifxFramer.self)

    required init(framer: NWProtocolFramer.Instance) {
        logger.debug("creating framer")
    }

    func start(framer: NWProtocolFramer.Instance) -> NWProtocolFramer.StartResult {
        logger.debug("starting")
        return .ready
    }

    func handleInput(framer: NWProtocolFramer.Instance) -> Int {
        logger.debug("handling input")
        _ = framer.parseInput(minimumIncompleteLength: 0, maximumLength: .max) { input, end in
            guard let input = input else { return 0 }

            let string = input.map {
                String(format: "%02x", $0)
            }.joined()
            logger.debug("\(string, privacy: .public)")

            var bytes = ByteReader(input: input)
            let size = bytes.readUInt16()
            logger.debug("message should be \(size)")

            guard input.count == size else {
                logger.debug("incomplete message of \(input.count)B")
                return 0
            }

            let frame = bytes.readFrame()
            let frameAddress = bytes.readFrameAddress()
            let protocolHeader = bytes.readProtocolHeader()

            let message = NWProtocolFramer.Message(definition: LifxFramer.definition)
            message.frame = frame
            message.frameAddress = frameAddress
            message.protocolHeader = protocolHeader

            _ = framer.deliverInputNoCopy(length: Int(size), message: message, isComplete: true)

            return Int(bytes.index)
        }
        return 0
    }

    func handleOutput(framer: NWProtocolFramer.Instance, message: NWProtocolFramer.Message, messageLength: Int, isComplete: Bool) {

        guard
            let frame = message.frame,
            let frameAddress = message.frameAddress,
            let protocolHeader = message.protocolHeader else {

            logger.fault("message is incomplete")
            return
        }

        logger.debug("handling output")


        var frameBytes = [UInt8]()
        var frameAddressBytes = [UInt8]()
        var protocolHeaderBytes = [UInt8]()
        var payloadBytes = [UInt8]()

        var `protocol` = frame.protocol
        withUnsafeBytes(of: &`protocol`) { protocolBytes in
            frameBytes.append(protocolBytes.first!)

            frameBytes.append(
                protocolBytes[1]
                + (frame.addressable ? 1 : 0) << 4
                + (frame.tagged ? 1 : 0) << 5
            )
        }

        var source = frame.source
        withUnsafeBytes(of: &source) { sourceBytes in
            frameBytes.append(contentsOf: sourceBytes)
        }



        var target = frameAddress.target
        withUnsafeBytes(of: &target) { targetBytes in
            frameAddressBytes.append(contentsOf: targetBytes)
        }

        // reserved
        frameAddressBytes.append(contentsOf: Array(repeating: UInt8.zero, count: 6))

        frameAddressBytes.append(
            frameAddress.responseRequired ? 1 : 0
            + (frameAddress.acknowledgementRequired ? 1 : 0) << 1
        )

        frameAddressBytes.append(frameAddress.sequence)


        // reserved
        protocolHeaderBytes.append(contentsOf: Array(repeating: UInt8.zero, count: 8))

        var type = protocolHeader.type
        withUnsafeBytes(of: &type) { typeBytes in
            protocolHeaderBytes.append(contentsOf: typeBytes)
        }

        // reserved
        protocolHeaderBytes.append(contentsOf: Array(repeating: UInt8.zero, count: 2))



        _ = framer.parseOutput(minimumIncompleteLength: .zero, maximumLength: .max) { (bytes, _) in
            guard let bytes = bytes else { return 0 }
            payloadBytes.append(contentsOf: bytes)
            return 0
        }


        var size: UInt16 = 2
            + UInt16(frameBytes.count)
            + UInt16(frameAddressBytes.count)
            + UInt16(protocolHeaderBytes.count)
            + UInt16(payloadBytes.count)
        withUnsafeBytes(of: &size) { sizeBytes in
            frameBytes.insert(contentsOf: sizeBytes, at: 0)
        }

        let bytes = frameBytes + frameAddressBytes + protocolHeaderBytes + payloadBytes

        logger.debug("frame bytes: \(frameBytes.count)B")
        logger.debug("frame address bytes: \(frameAddressBytes.count)B")
        logger.debug("protocol header bytes: \(protocolHeaderBytes.count)B")
        logger.debug("payload bytes: \(payloadBytes.count)B")
        logger.debug("total bytes: \(bytes.count)B")

        let string = bytes.map {
            String(format: "%02x", $0)
        }.joined()
        logger.debug("\(string, privacy: .public)")

        let data = Data(bytes: bytes, count: bytes.count)

        framer.writeOutput(data: data)
    }

    func wakeup(framer: NWProtocolFramer.Instance) {
        logger.debug("waking")
    }

    func stop(framer: NWProtocolFramer.Instance) -> Bool {
        logger.debug("stopping")
        return true
    }

    func cleanup(framer: NWProtocolFramer.Instance) {
        logger.debug("cleaning")
    }
}

extension UInt8 {
    func has(bit index: UInt8) -> Bool {
        bit(at: index) == 1
    }

    func bit(at index: UInt8) -> UInt8 {
        (self & (1 << index)) >> index
    }
}

private extension ByteReader {
    mutating func readFrame() -> LifxFrame {
        let protocolLow = readUInt8()
        let protocolHigh = readUInt8()
        let proto = UInt16(protocolLow) + (UInt16(protocolHigh) >> 4) << 12

        let addressable = protocolHigh.has(bit: 3)
        let tagged = protocolHigh.has(bit: 2)

        let origin = protocolHigh.bit(at: 6) + protocolHigh.bit(at: 7) << 1

        let source = readUInt32()

        return LifxFrame(protocol: proto, addressable: addressable, tagged: tagged, origin: origin, source: source)
    }

    mutating func readFrameAddress() -> LifxFrameAddress {
        let target = LifxFrameAddress.Target(byte0: readUInt8(),
            byte1: readUInt8(),
            byte2: readUInt8(),
            byte3: readUInt8(),
            byte4: readUInt8(),
            byte5: readUInt8(),
            byte6: readUInt8(),
            byte7: readUInt8())

        // reserved
        skip(count: 6)

        let responseAcknowledgement = readUInt8()
        let responseRequired = responseAcknowledgement.has(bit: 0)
        let acknowledgementRequired = responseAcknowledgement.has(bit: 1)

        let sequence = readUInt8()

        return LifxFrameAddress(target: target,
            responseRequired: responseRequired, acknowledgementRequired: acknowledgementRequired, sequence: sequence)
    }

    mutating func readProtocolHeader() -> LifxProtocolHeader {
        // reserved
        skip(type: UInt64.self)

        let type = readUInt16()

        // reserved
        skip(type: UInt16.self)

        return  LifxProtocolHeader(type: type)
    }
}
