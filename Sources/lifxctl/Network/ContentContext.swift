//
//  ContentContext.swift
//  
//
//  Created by Gareth Redman on 8/03/21.
//

import Network

extension NWConnection.ContentContext {
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
}
