import XCTest
@testable import MiniBuddy

@MainActor
final class AppRouterNavigationTests: XCTestCase {
    override func tearDown() {
        ActiveGameContextPersistence.resetForTests()
        super.tearDown()
    }

    func testOpenGuidedMatchSetsTabPathAndActiveGameSystem() {
        let router = AppRouter()

        router.openGuidedMatch(gameSystemId: "aos-spearhead")

        XCTAssertEqual(router.selectedTab, .learn)
        XCTAssertEqual(router.activeGameSystemId, "aos-spearhead")
        XCTAssertEqual(router.learnPath.count, 1)
    }

    func testOpenGameGuideForGatedSystemKeepsVisibleActiveSystem() {
        XCTAssertFalse(ReleaseSurface.isGameSystemIdVisible("wh40k-11e"))
        let router = AppRouter()

        router.openGameGuide(gameSystemId: "wh40k-11e")

        XCTAssertEqual(router.selectedTab, .learn)
        XCTAssertEqual(router.activeGameSystemId, "aos-spearhead")
        XCTAssertEqual(router.learnPath.count, 1)
    }

    func testOpenGameGuidePopsToRootWhenSingleGame() {
        let router = AppRouter()
        router.openGuidedMatch(gameSystemId: "aos-spearhead")
        XCTAssertEqual(router.learnPath.count, 1)

        router.openGameGuide(gameSystemId: "aos-spearhead")

        XCTAssertEqual(router.selectedTab, .learn)
        XCTAssertEqual(router.learnPath.count, 0)
    }

    func testOpenRulesSearchQueuesQueryAndSwitchesTab() {
        let router = AppRouter()

        router.openRulesSearch(gameSystemId: "aos-spearhead", query: "Command Phase")

        XCTAssertEqual(router.selectedTab, .search)
        XCTAssertEqual(router.activeGameSystemId, "aos-spearhead")
        XCTAssertEqual(router.consumePendingRulesSearchQuery(), "Command Phase")
        XCTAssertNil(router.consumePendingRulesSearchQuery())
    }

    func testOpenMusterRedirectsToCollectionWhenMusterGated() {
        // Default release surface (no -enable_full_product_surface): the Lists/Muster tab is
        // gated, so muster routing must fall back to Collection rather than select a tab that
        // isn't rendered in RootTabView.
        XCTAssertFalse(ReleaseSurface.showsMusterTab)

        let router = AppRouter()
        router.openMuster(rosterId: UUID())

        XCTAssertEqual(router.selectedTab, .bench)
        XCTAssertEqual(router.hobbyTab, .armies)
        XCTAssertNil(router.pendingRosterId)
        XCTAssertNil(router.selectedRosterId)
    }

    func testOpenMusterHomeDeepLinkRedirectsToCollectionWhenGated() {
        XCTAssertFalse(ReleaseSurface.showsMusterTab)

        let router = AppRouter()
        router.open(.musterHome)

        XCTAssertEqual(router.selectedTab, .bench)
        XCTAssertEqual(router.hobbyTab, .armies)
    }

    func testSetActiveGameSystemPersistsAndFallsBackWhenGated() {
        let router = AppRouter()
        router.setActiveGameSystem("wh40k-10e-cp")
        XCTAssertEqual(
            UserDefaults.standard.string(forKey: ActiveGameContextPersistence.storageKey),
            "wh40k-10e-cp"
        )
        XCTAssertEqual(AppRouter().activeGameSystemId, "aos-spearhead")
    }
}
