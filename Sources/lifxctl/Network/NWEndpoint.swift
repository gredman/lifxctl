import Network

extension NWEndpoint.Port {
    static let lifxPort: NWEndpoint.Port = 56700
}

extension NWEndpoint {
    static func lifx(string: String) -> NWEndpoint {
        let host = NWEndpoint.Host(string)
        return NWEndpoint.hostPort(host: host, port: .lifxPort)
    }
}
