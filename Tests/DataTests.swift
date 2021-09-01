import XCTest
@testable import Secrets

final class DataTests: XCTestCase {
    func testEncryption() async {
        let original = "hello world"
        let round = String(decoding: await Data(original.utf8).encrypted.decrypted, as: UTF8.self)
        XCTAssertEqual(round, original)
    }
}
