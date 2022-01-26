import ArgumentParser
import Foundation
import Network
import os

private let logger = Logger(category: "Get")

struct SetWaveform: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Set waveform")

    @Option(help: "Address") var address = IPv4Address.broadcast

    @Flag(inversion: .prefixedNo, help: "Transient") var transient = true
    @Option(help: "Hue") var hue = Angle(rawValue: 0)
    @Option(help: "Saturation") var saturation = Percentage(rawValue: 100)
    @Option(help: "Brightness") var brightness = Percentage(rawValue: 100)
    @Option(help: "Kelvin") var kelvin = Temperature(rawValue: 2500)
    @Option(help: "Period in milliseconds") var period: UInt32
    @Option(help: "Cycles") var cycles: Float32 = 1
    @Option(help: "Skew ratio") var skewRatio: SkewRatio = 0.5
    @Option(help: "Waveform (allowed: \(Waveform.allValueStrings.joined(separator: ", ")))") var waveform: Waveform = .sine

    func run() throws {
        var payload = Data()
        payload.appendBytes(of: UInt8.zero)
        payload.appendBytes(of: transient ? UInt8(1) : UInt8.zero)
        payload.appendBytes(of: hue.uint16)
        payload.appendBytes(of: saturation.uint16)
        payload.appendBytes(of: brightness.uint16)
        payload.appendBytes(of: kelvin.uint16)
        payload.appendBytes(of: period)
        payload.appendBytes(of: cycles)
        payload.appendBytes(of: skewRatio.int16)
        payload.appendBytes(of: waveform.uint8)

        let host = NWEndpoint.hostPort(host: .ipv4(address), port: .lifxPort)
        let connection = NWConnection(to: host, using: .lifx)

        connection.start(queue: .main)
        connection.send(content: payload, contentContext: .setWaveform, isComplete: true, completion: .contentProcessed({ error in
            logger.debug("content processed with error = \(String(describing: error), privacy: .public)")
            On.exit(withError: error)
        }))

        dispatchMain()
    }

}
