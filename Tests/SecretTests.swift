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
    
    func testData() {
        let date = Date(timeIntervalSinceNow: -10000)
        
        secret = secret.with(name: "secret name")
        secret = secret.with(payload: "some payload")
        secret = secret.with(date: date)
        secret = secret.with(favourite: true)
        secret = secret.with(tags: [.pet, .food, .books])
        
        secret = secret.data.prototype()
        
        XCTAssertEqual("secret name", secret.name)
        XCTAssertEqual("some payload", secret.payload)
        XCTAssertEqual(date.timestamp, secret.date.timestamp)
        XCTAssertTrue(secret.favourite)
        XCTAssertTrue(secret.tags.contains(.pet))
        XCTAssertTrue(secret.tags.contains(.food))
        XCTAssertTrue(secret.tags.contains(.books))
    }
}
