import Network

extension NWConnection.ContentContext {
    static var get: NWConnection.ContentContext {
        let message = NWProtocolFramer.Message.get
        return NWConnection.ContentContext(
            identifier: "Light::Get",
            metadata: [message])
    }

    static var setPower: NWConnection.ContentContext {
        let message = NWProtocolFramer.Message.setPower
        return NWConnection.ContentContext(
            identifier: "Light::SetPower",
            metadata: [message])
    }

    static var setColor: NWConnection.ContentContext {
        let message = NWProtocolFramer.Message.setColor
        return NWConnection.ContentContext(
            identifier: "Light::SetColor",
            metadata: [message])
    }
    
    static var setWaveform: NWConnection.ContentContext {
        let message = NWProtocolFramer.Message.setWaveform
        return NWConnection.ContentContext(
            identifier: "Light::SetColor",
            metadata: [message])
    }
}
