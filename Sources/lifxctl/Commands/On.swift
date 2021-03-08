//
//  On.swift
//  
//
//  Created by Gareth Redman on 7/03/21.
//

import ArgumentParser
import Foundation
import Network
import os

private let logger = Logger(category: "On")

struct On: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Turn bulb on")

    @Argument(help: "Address") var address: String

    @Argument(help: "Duration in milliseconds") var duration: UInt32 = 0

    func run() throws {
        let message = NWProtocolFramer.Message(definition: LifxFramer.definition)

        var frame = LifxFrame()
        frame.tagged = true
        message.frame = frame
        message.frameAddress = LifxFrameAddress(target: 0)
        message.protocolHeader = LifxProtocolHeader.setPower

        let context = NWConnection.ContentContext(
            identifier: "Light::SetPower",
            metadata: [message])

        var contentBytes = [UInt8]()
        var level = UInt16.max
        var duration = self.duration

        withUnsafeBytes(of: &level) { bytes in
            contentBytes.append(contentsOf: bytes)
        }
        withUnsafeBytes(of: &duration) { bytes in
            contentBytes.append(contentsOf: bytes)
        }
        let content = Data(bytes: contentBytes, count: contentBytes.count)

        let parameters = NWParameters.udp
        parameters
            .defaultProtocolStack
            .applicationProtocols
            .insert(NWProtocolFramer.Options(definition: LifxFramer.definition), at: 0)
        let host = NWEndpoint.lifx(string: address)
        let connection = NWConnection(to: host, using: parameters)

        connection.start(queue: .main)
        connection.send(content: content, contentContext: context, isComplete: true, completion: .contentProcessed({ error in
            logger.debug("content processed with error = \(String(describing: error), privacy: .public)")
            On.exit(withError: error)
        }))

        dispatchMain()
    }
}
