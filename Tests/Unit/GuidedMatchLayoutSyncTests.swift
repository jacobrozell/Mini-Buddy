import XCTest
@testable import MiniBuddy

final class GuidedMatchLayoutSyncTests: XCTestCase {
    func testHubTabFromDestination() {
        XCTAssertEqual(
            GuidedMatchLayoutSync.hubTab(for: .battleTracker, current: .armies),
            .battle
        )
        XCTAssertEqual(
            GuidedMatchLayoutSync.hubTab(for: .step("deploy"), current: .armies),
            .setup
        )
        XCTAssertEqual(
            GuidedMatchLayoutSync.hubTab(for: .playerOne, current: .setup),
            .armies
        )
        XCTAssertEqual(
            GuidedMatchLayoutSync.hubTab(for: nil, current: .setup),
            .setup
        )
    }

    func testDestinationFromHubTab() {
        XCTAssertEqual(
            GuidedMatchLayoutSync.destination(
                for: .battle,
                showsBattle: true,
                nextIncompleteStepId: nil,
                current: nil
            ),
            .battleTracker
        )
        XCTAssertNil(
            GuidedMatchLayoutSync.destination(
                for: .battle,
                showsBattle: false,
                nextIncompleteStepId: nil,
                current: nil
            )
        )
        XCTAssertEqual(
            GuidedMatchLayoutSync.destination(
                for: .setup,
                showsBattle: false,
                nextIncompleteStepId: "realm",
                current: .playerOne
            ),
            .step("realm")
        )
    }
}
