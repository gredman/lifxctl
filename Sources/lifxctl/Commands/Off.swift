//
//  Off.swift
//  
//
//  Created by Gareth Redman on 7/03/21.
//

import ArgumentParser
import Foundation
import Network
import os

private let logger = Logger(category: "Off")

struct Off: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Turn bulb off")

    @Argument(help: "Address") var address: String

    @Argument(help: "Duration in milliseconds") var duration: UInt32 = 0

    func run() throws {
        var contentBytes = [UInt8]()
        var level = UInt16.zero
        var duration = self.duration

        withUnsafeBytes(of: &level) { bytes in
            contentBytes.append(contentsOf: bytes)
        }
        withUnsafeBytes(of: &duration) { bytes in
            contentBytes.append(contentsOf: bytes)
        }
        let content = Data(bytes: contentBytes, count: contentBytes.count)

        let host = NWEndpoint.lifx(string: address)
        let connection = NWConnection(to: host, using: .lifx)

        connection.start(queue: .main)
        connection.send(content: content, contentContext: .setPower, isComplete: true, completion: .contentProcessed({ error in
            logger.debug("content processed with error = \(String(describing: error), privacy: .public)")
            Off.exit(withError: error)
        }))

        dispatchMain()
    }
}
