import XCTest
import Combine
import Archivable
@testable import Secrets

final class CloudTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() async throws {
        cloud = await .init(container: nil)
        subs = []
    }
    
    func testNew() async {
        let expect = expectation(description: "")
        let date = Date()
        
        cloud
            .archive
            .dropFirst()
            .sink {
                XCTAssertEqual(2, $0.secrets.count)
                XCTAssertEqual("hello world", $0.secrets.first?.payload)
                XCTAssertEqual("lorem ipsum", $0.secrets.last?.payload)
                XCTAssertGreaterThanOrEqual($0.timestamp, date.timestamp)
                XCTAssertGreaterThanOrEqual($0.secrets.first?.date.timestamp ?? 0, date.timestamp)
                XCTAssertGreaterThanOrEqual($0.secrets.last?.date.timestamp ?? 0, date.timestamp)
                XCTAssertFalse($0.available)
                expect.fulfill()
            }
            .store(in: &subs)
        
        let first = await cloud.new(secret: "hello world")
        let second = await cloud.new(secret: "lorem ipsum")
        
        XCTAssertEqual(0, first)
        XCTAssertEqual(1, second)
        
        await waitForExpectations(timeout: 1)
    }
    
    func testUpdateName() async {
        let expect = expectation(description: "")
        _ = await cloud.new(secret: "hello world")
        let date = Date()
        
        cloud
            .archive
            .sink {
                XCTAssertEqual("lorem ipsum", $0.secrets.first?.name)
                XCTAssertGreaterThanOrEqual($0.secrets.last?.date.timestamp ?? 0, date.timestamp)
                expect.fulfill()
            }
            .store(in: &subs)
        
        await cloud.update(index: 0, name: "lorem ipsum")
        
        await waitForExpectations(timeout: 1)
    }
}
