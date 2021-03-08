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
        var payload = Data()
        payload.appendBytes(of: UInt16.max)
        payload.appendBytes(of: duration)

        let host = NWEndpoint.lifx(string: address)
        let connection = NWConnection(to: host, using: .lifx)

        connection.start(queue: .main)
        connection.send(content: payload, contentContext: .setPower, isComplete: true, completion: .contentProcessed({ error in
            logger.debug("content processed with error = \(String(describing: error), privacy: .public)")
            On.exit(withError: error)
        }))

        dispatchMain()
    }
}
