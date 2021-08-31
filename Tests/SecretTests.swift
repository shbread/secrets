import XCTest
@testable import Secrets

final class SecretTests: XCTestCase {
    private var secret: Secret!
    
    override func setUp() {
        secret = .new
    }
    
    func testName() {
        XCTAssertEqual("Untitled", secret.name)
    }
    
    func testFavourite() {
        XCTAssertFalse(secret.favourite)
    }
    
    func testTags() {
        XCTAssertTrue(secret.tags.isEmpty)
    }
}
