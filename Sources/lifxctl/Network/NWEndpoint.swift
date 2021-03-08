//
//  NWEndpoint.swift
//  
//
//  Created by Gareth Redman on 8/03/21.
//

import Network

extension NWEndpoint {
    static func lifx(string: String) -> NWEndpoint {
        let host = NWEndpoint.Host(string)
        return NWEndpoint.hostPort(host: host, port: 56700)
    }
}
