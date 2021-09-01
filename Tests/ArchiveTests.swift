import XCTest
@testable import Archivable
@testable import Secrets

final class ArchiveTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .new
    }
    
    func testAvailable() {
        XCTAssertTrue(archive.available)
        archive.secrets = [.new]
        XCTAssertFalse(archive.available)
    }
}
