import ArgumentParser
import Network

extension IPv4Address: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(argument)
    }
}
