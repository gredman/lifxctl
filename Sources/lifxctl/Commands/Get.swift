//
//  Get.swift
//  
//
//  Created by Gareth Redman get 9/03/21.
//

import ArgumentParser
import Foundation
import Network
import os

private let logger = Logger(category: "Get")

struct Get: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Get current light state")

    @Argument(help: "Address") var address: String

    func run() throws {
        let host = NWEndpoint.lifx(string: address)
        let connection = NWConnection(to: host, using: .lifx)

        connection.start(queue: .main)
        connection.send(content: nil, contentContext: .get, isComplete: true, completion: .contentProcessed({ error in
            logger.debug("content processed with error = \(String(describing: error), privacy: .public)")
        }))
        connection.receiveMessage { data, context, isComplete, error in
            logger.debug("received message with error = \(String(describing: error), privacy: .public)")
            if let metadata = context?.protocolMetadata(definition: LifxFramer.definition) as? NWProtocolFramer.Message,
               let data = data {
                logger.debug("got metadata \(String(describing: metadata), privacy: .public)")
                logger.debug("got payload \(data.count)B")

                data.withUnsafeBytes { pointer in
                    var reader = ByteReader(input: pointer)
                    let payload = reader.readPayload()
                    print(payload: payload)
                }

                Get.exit(withError: error)
            }
        }

        dispatchMain()
    }

    private func print(payload: Payload) {
        Swift.print("hue: \(payload.hue.rawValue)°")
        Swift.print("saturation: \(payload.saturation.rawValue)%")
        Swift.print("brightness: \(payload.brightness.rawValue)%")
        Swift.print("kelvin: \(payload.kelvin.rawValue)K")
        Swift.print("power: \(payload.power ? "on" : "off")")
        Swift.print("label: \(payload.label)")
    }
}

private struct Payload {
    let hue: Angle
    let saturation: Percentage
    let brightness: Percentage
    let kelvin: Temperature
    let power: Bool
    let label: String
}

private extension ByteReader {
    mutating func readPayload() -> Payload {
        let hue = readUInt16()
        let saturation = readUInt16()
        let brightness = readUInt16()
        let kelvin = readUInt16()
        skip(type: UInt16.self)
        let power = readUInt16()
        let label = readString(length: 32)
        skip(type: UInt64.self)

        return Payload(
            hue: Angle(uint16: hue),
            saturation: Percentage(uint16: saturation),
            brightness: Percentage(uint16: brightness),
            kelvin: Temperature(uint16: kelvin),
            power: power != 0,
            label: label)
    }
}
