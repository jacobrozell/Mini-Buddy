import XCTest
@testable import MiniBuddy
@testable import MiniBuddyDomain

final class ActiveGameContextPersistenceTests: XCTestCase {
    override func tearDown() {
        ActiveGameContextPersistence.resetForTests()
        super.tearDown()
    }

    func testPersistsActiveGameSystemId() {
        ActiveGameContextPersistence.gameSystemId = GameSystemId.aosSpearhead.rawValue
        XCTAssertEqual(
            ActiveGameContextPersistence.gameSystemId,
            GameSystemId.aosSpearhead.rawValue
        )
    }
}
