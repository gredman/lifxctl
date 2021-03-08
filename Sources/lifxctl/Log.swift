//
//  Log.swift
//  
//
//  Created by Gareth Redman on 7/03/21.
//

import os

extension Logger {
    init(category: String) {
        self.init(subsystem: "computer.gareth.lifxctl", category: category)
    }
}
