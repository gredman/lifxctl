import Network

extension NWProtocolFramer.Message {
    var frame: LifxFrame? {
        get { self["frame"] as? LifxFrame}
        set { self["frame"] = newValue }
    }

    var frameAddress: LifxFrameAddress? {
        get { self["frameAddress"] as? LifxFrameAddress }
        set { self["frameAddress"] = newValue }
    }

    var protocolHeader: LifxProtocolHeader? {
        get { self["protocolHeader"] as? LifxProtocolHeader }
        set { self["protocolHeader"] = newValue }
    }

    static var get: NWProtocolFramer.Message {
        let message = NWProtocolFramer.Message(definition: LifxFramer.definition)

        var frame = LifxFrame()
        frame.tagged = true
        message.frame = frame
        message.frameAddress = LifxFrameAddress()
        message.protocolHeader = LifxProtocolHeader.get

        return message
    }

    static var setPower: NWProtocolFramer.Message {
        let message = NWProtocolFramer.Message(definition: LifxFramer.definition)

        var frame = LifxFrame()
        frame.tagged = true
        message.frame = frame
        message.frameAddress = LifxFrameAddress()
        message.protocolHeader = LifxProtocolHeader.setPower

        return message
    }

    static var setColor: NWProtocolFramer.Message {
        let message = NWProtocolFramer.Message(definition: LifxFramer.definition)

        var frame = LifxFrame()
        frame.tagged = true
        message.frame = frame
        message.frameAddress = LifxFrameAddress()
        message.protocolHeader = LifxProtocolHeader.setColor

        return message
    }
    
    static var setWaveform: NWProtocolFramer.Message {
        let message = NWProtocolFramer.Message(definition: LifxFramer.definition)

        var frame = LifxFrame()
        frame.tagged = true
        message.frame = frame
        message.frameAddress = LifxFrameAddress()
        message.protocolHeader = LifxProtocolHeader.setWaveform

        return message
    }
}
