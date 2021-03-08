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
        framer.parseInput(minimumIncompleteLength: 0, maximumLength: .max) { bytes, end in
            guard let bytes = bytes else { return 0 }
//            for byte in bytes {
//                logger.debug("\(byte, format: .hex)")
//            }

            let string = bytes.map {
                String(format: "%02x", $0)
            }.joined()
            logger.debug("\(string, privacy: .public)")

            return 0
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
