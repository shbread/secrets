import Foundation
import Archivable

public struct Secret: Storable {
    static let new = Self()
    public let name: String
    public let payload: String
    public let date: Date
    public let favourite: Bool
    public let tags: [Tag]
    
    public var data: Data {
        .init()
    }
    
    public init(data: inout Data) async {
        name = ""
        payload = ""
        date = .init()
        favourite = false
        tags = []
    }
    
    private init() {
        name = "Untitled"
        payload = ""
        date = .init()
        favourite = false
        tags = []
    }
}
