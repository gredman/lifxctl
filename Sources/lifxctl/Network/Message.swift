//
//  Message.swift
//  
//
//  Created by Gareth Redman on 7/03/21.
//

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

    static var setPower: NWProtocolFramer.Message {
        let message = NWProtocolFramer.Message(definition: LifxFramer.definition)

        var frame = LifxFrame()
        frame.tagged = true
        message.frame = frame
        message.frameAddress = LifxFrameAddress(target: 0)
        message.protocolHeader = LifxProtocolHeader.setPower

        return message
    }
}