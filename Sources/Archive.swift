import Foundation
import Archivable

public struct Archive: Arch {
    public static let new = Self()
    public var timestamp: UInt32
    public internal(set) var secrets: [Secret]
    public internal(set) var capacity: Int
    
    public var available: Bool {
        secrets.count < capacity
    }
    
    public var data: Data {
        get {
            .init()
        }
    }
    
    private init() {
        timestamp = .now
        secrets = []
        capacity = 1
    }
    
    public init(data: inout Data) async {
        timestamp = .now
        secrets = []
        capacity = 1
    }
}
