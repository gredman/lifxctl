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
        var payload = Data()
        payload.appendBytes(of: UInt16.zero)
        payload.appendBytes(of: duration)

        let host = NWEndpoint.lifx(string: address)
        let connection = NWConnection(to: host, using: .lifx)

        connection.start(queue: .main)
        connection.send(content: payload, contentContext: .setPower, isComplete: true, completion: .contentProcessed({ error in
            logger.debug("content processed with error = \(String(describing: error), privacy: .public)")
            Off.exit(withError: error)
        }))

        dispatchMain()
    }
}
