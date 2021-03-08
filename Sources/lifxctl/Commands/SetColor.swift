//
//  SetColor.swift
//  
//
//  Created by Gareth Redman on 8/03/21.
//

import ArgumentParser
import Foundation
import Network
import os

private let logger = Logger(category: "SetColor")

struct SetColor: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Turn bulb on")

    @Argument(help: "Address") var address: String

    @Option(help: "Hue") var hue = Angle(rawValue: 0)
    @Option(help: "Saturation") var saturation = Percentage(rawValue: 100)
    @Option(help: "Brightness") var brightness = Percentage(rawValue: 100)
    @Option(help: "Kelvin") var kelvin = Temperature(rawValue: 2500)
    @Option(help: "Duration in milliseconds") var duration: UInt32 = 0

    func run() throws {
        let payload = Data(UInt8.zero, hue.uint16, saturation.uint16, brightness.uint16, kelvin.uint16, duration)

        let host = NWEndpoint.lifx(string: address)
        let connection = NWConnection(to: host, using: .lifx)

        connection.start(queue: .main)
        connection.send(content: payload, contentContext: .setColor, isComplete: true, completion: .contentProcessed({ error in
            logger.debug("content processed with error = \(String(describing: error), privacy: .public)")
            On.exit(withError: error)
        }))

        dispatchMain()
    }
}
