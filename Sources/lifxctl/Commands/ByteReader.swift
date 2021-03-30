import Foundation

struct ByteReader {
    private let bytes: UnsafeBufferPointer<UInt8>
    private(set) var index: UnsafeBufferPointer<UInt8>.Index

    init(input: UnsafeMutableRawBufferPointer) {
        self.init(input: UnsafeRawBufferPointer(input))
    }

    init(input: UnsafeRawBufferPointer) {
        bytes = input.bindMemory(to: UInt8.self)
        index = bytes.startIndex
    }

    mutating func readUInt8() -> UInt8 {
        defer { index += 1 }
        return bytes[index]
    }

    mutating func readUInt16() -> UInt16 {
        defer { index += UInt16.bitWidth / UInt8.bitWidth }
        return UInt16(bytes[index]) + (UInt16(bytes[index+1]) << UInt8.bitWidth)
    }

    mutating func readUInt32() -> UInt32 {
        defer { index += UInt32.bitWidth / UInt8.bitWidth }
        return UInt32(bytes[index])
            + (UInt32(bytes[index+1]) << UInt8.bitWidth)
            + (UInt32(bytes[index+2]) << UInt8.bitWidth*2)
            + (UInt32(bytes[index+3]) << UInt8.bitWidth*3)
    }

    mutating func readString(length: Int) -> String {
        let bytes = (0..<length).map { _ in readUInt8() }
        return String(bytes: bytes, encoding: .utf8)!
    }

    mutating func skip(count: Int) {
        index += count
    }

    mutating func skip<T>(type: T.Type) where T: FixedWidthInteger {
        index += T.bitWidth / UInt8.bitWidth
    }
}
