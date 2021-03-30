import Network

extension NWParameters {
    static var lifx: NWParameters {
        let parameters = NWParameters.udp
        parameters
            .defaultProtocolStack
            .applicationProtocols
            .insert(NWProtocolFramer.Options(definition: LifxFramer.definition), at: 0)
        return parameters
    }
}
