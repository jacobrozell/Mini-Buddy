import CoreGraphics
import XCTest
@testable import Tabletome

final class BattleScreenArrangementTests: XCTestCase {
    func testShortHeightAlwaysTwoColumn() {
        XCTAssertEqual(
            BattleScreenArrangement.resolve(
                context: .shortHeight,
                containerSize: CGSize(width: 400, height: 300),
                needsLayoutAdaptation: false
            ),
            .twoColumn
        )
        XCTAssertEqual(
            BattleScreenArrangement.resolve(
                context: .shortHeight,
                containerSize: CGSize(width: 400, height: 300),
                needsLayoutAdaptation: true
            ),
            .twoColumn
        )
    }

    func testWideAtLargeRegularContainer() {
        XCTAssertEqual(
            BattleScreenArrangement.resolve(
                context: .regular,
                containerSize: CGSize(width: 1024, height: 768),
                needsLayoutAdaptation: false
            ),
            .wide
        )
    }

    func testStackedOnNarrowRegularContainer() {
        XCTAssertEqual(
            BattleScreenArrangement.resolve(
                context: .regular,
                containerSize: CGSize(width: 500, height: 1000),
                needsLayoutAdaptation: false
            ),
            .stacked
        )
    }

    func testStackedOnPhonePortrait() {
        XCTAssertEqual(
            BattleScreenArrangement.resolve(
                context: .compact,
                containerSize: CGSize(width: 393, height: 852),
                needsLayoutAdaptation: false
            ),
            .stacked
        )
    }

    func testStackedAtAccessibilityOnWideContainer() {
        XCTAssertEqual(
            BattleScreenArrangement.resolve(
                context: .regular,
                containerSize: CGSize(width: 1024, height: 768),
                needsLayoutAdaptation: true
            ),
            .stacked
        )
    }

    func testSidebarWidthClamps() {
        XCTAssertEqual(BattleScreenArrangement.sidebarWidth(containerWidth: 600), 220)
        XCTAssertEqual(BattleScreenArrangement.sidebarWidth(containerWidth: 1200), 300)
    }

    func testNowColumnWidthClamps() {
        XCTAssertEqual(BattleScreenArrangement.nowColumnWidth(containerWidth: 800), 380)
        XCTAssertEqual(BattleScreenArrangement.nowColumnWidth(containerWidth: 1400), 520)
    }
}
