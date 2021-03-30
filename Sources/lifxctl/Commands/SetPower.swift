//
//  SetPower.swift
//  
//
//  Created by Gareth Redman on 30/03/21.
//

import ArgumentParser

struct SetPower: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Turn bulb on on or off", subcommands: [On.self, Off.self])
}
