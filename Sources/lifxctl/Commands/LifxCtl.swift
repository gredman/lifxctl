import ArgumentParser

struct LifxCtl: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "lifxctl",
        abstract: "Control lifx bulbs",
        version: "0.0.0",
        subcommands: [
            Get.self,
            SetPower.self,
            SetColor.self,
            SetWaveform.self
        ])
}
