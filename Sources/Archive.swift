import Foundation
import Archivable

public struct Archive: Arch {
    public static let version = UInt8()
    public static let new = Self()
    public var timestamp: UInt32
    public internal(set) var secrets: [Secret]
    public internal(set) var capacity: Int
    
    public var available: Bool {
        secrets.count < capacity
    }
    
    public var data: Data {
        get async {
            await .init()
                .adding(UInt16(capacity))
                .adding(UInt16(secrets.count))
                .adding(secrets.flatMap(\.data))
        }
    }
    
    private init() {
        timestamp = .now
        secrets = []
        capacity = 1
    }
    
    public init(version: UInt8, timestamp: UInt32, data: inout Data) async {
        self.timestamp = timestamp
        secrets = []
        capacity = .init(data.uInt16())
        secrets = (0 ..< .init(data.uInt16()))
            .map { _ in
                .init(data: &data)
            }
    }
}
