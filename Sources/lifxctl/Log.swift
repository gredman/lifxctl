import os

extension Logger {
    init(category: String) {
        self.init(subsystem: "computer.gareth.lifxctl", category: category)
    }
}
