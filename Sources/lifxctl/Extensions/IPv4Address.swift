//
//  IPv4Address.swift
//
//
//  Created by Gareth Redman on 13/03/21.
//

import ArgumentParser
import Network

extension IPv4Address: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(argument)
    }
}
