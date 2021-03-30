import ArgumentParser
import Foundation
import Network
import os

private let logger = Logger(category: "SetColor")

struct SetColor: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Turn bulb on")

    @Option(help: "Address") var address = IPv4Address.broadcast

    @Option(help: "Hue") var hue = Angle(rawValue: 0)
    @Option(help: "Saturation") var saturation = Percentage(rawValue: 100)
    @Option(help: "Brightness") var brightness = Percentage(rawValue: 100)
    @Option(help: "Kelvin") var kelvin = Temperature(rawValue: 2500)
    @Option(help: "Duration in milliseconds") var duration: UInt32 = 0

    func run() throws {
        var payload = Data()
        payload.appendBytes(of: UInt8.zero)
        payload.appendBytes(of: hue.uint16)
        payload.appendBytes(of: saturation.uint16)
        payload.appendBytes(of: brightness.uint16)
        payload.appendBytes(of: kelvin.uint16)
        payload.appendBytes(of: duration)

        let host = NWEndpoint.hostPort(host: .ipv4(address), port: .lifxPort)
        let connection = NWConnection(to: host, using: .lifx)

        connection.start(queue: .main)
        connection.send(content: payload, contentContext: .setColor, isComplete: true, completion: .contentProcessed({ error in
            logger.debug("content processed with error = \(String(describing: error), privacy: .public)")
            On.exit(withError: error)
        }))

        dispatchMain()
    }
}
