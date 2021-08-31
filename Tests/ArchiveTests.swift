import XCTest
@testable import Secrets

final class ArchiveTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .new
    }
    
    func testCapacity() {
        XCTAssertEqual(1, archive.capacity)
    }
    
    func testAvailable() {
        XCTAssertTrue(archive.available)
        archive.secrets = [.new]
        XCTAssertFalse(archive.available)
    }
}
