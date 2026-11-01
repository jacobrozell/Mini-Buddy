import SwiftUI
import XCTest
@testable import Tabletome

final class TabletomeLayoutTests: XCTestCase {
    func testContextFromSizeClasses() {
        assertContext(.compact, .regular, equals: .compact)
        assertContext(.compact, .compact, equals: .shortHeight)
        assertContext(.regular, .compact, equals: .shortHeight)
        assertContext(.regular, .regular, equals: .regular)
        assertContext(nil, nil, equals: .compact)
    }

    private func assertContext(
        _ horizontal: UserInterfaceSizeClass?,
        _ vertical: UserInterfaceSizeClass?,
        equals expected: TabletomeLayoutContext,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(
            TabletomeLayout.context(horizontalSizeClass: horizontal, verticalSizeClass: vertical),
            expected,
            file: file,
            line: line
        )
    }

    func testUsesSplitNavigationRequiresRegularRegular() {
        XCTAssertTrue(
            TabletomeLayout.usesSplitNavigation(
                horizontalSizeClass: .regular,
                verticalSizeClass: .regular
            )
        )
        XCTAssertFalse(
            TabletomeLayout.usesSplitNavigation(
                horizontalSizeClass: .regular,
                verticalSizeClass: .compact
            )
        )
        XCTAssertFalse(
            TabletomeLayout.usesSplitNavigation(
                horizontalSizeClass: .compact,
                verticalSizeClass: .regular
            )
        )
    }

    func testUsesSplitNavigationDisabledAtAccessibilitySizes() {
        XCTAssertFalse(
            TabletomeLayout.usesSplitNavigation(
                horizontalSizeClass: .regular,
                verticalSizeClass: .regular,
                dynamicTypeSize: .accessibility1
            )
        )
    }

    func testPrefersCompactGuidedMatchChrome() {
        XCTAssertTrue(TabletomeLayout.prefersCompactGuidedMatchChrome(.shortHeight, containerHeight: 400))
        XCTAssertFalse(TabletomeLayout.prefersCompactGuidedMatchChrome(.regular, containerHeight: 800))
        XCTAssertTrue(TabletomeLayout.prefersCompactGuidedMatchChrome(.compact, containerHeight: 667))
        XCTAssertFalse(TabletomeLayout.prefersCompactGuidedMatchChrome(.compact, containerHeight: 852))
        XCTAssertFalse(TabletomeLayout.prefersCompactGuidedMatchChrome(.compact, containerHeight: 0))
    }

    func testUsesSideBySideLayout() {
        XCTAssertTrue(
            TabletomeLayout.usesSideBySideLayout(
                horizontalSizeClass: .regular,
                verticalSizeClass: .regular
            )
        )
        XCTAssertFalse(
            TabletomeLayout.usesSideBySideLayout(
                horizontalSizeClass: .regular,
                verticalSizeClass: .compact
            )
        )
        XCTAssertFalse(
            TabletomeLayout.usesSideBySideLayout(
                horizontalSizeClass: .regular,
                verticalSizeClass: .regular,
                isAccessibilitySize: true
            )
        )
    }

    func testUsesPairedPlayerColumnsInLandscape() {
        XCTAssertTrue(
            TabletomeLayout.usesPairedPlayerColumns(
                horizontalSizeClass: .compact,
                verticalSizeClass: .compact
            )
        )
        XCTAssertTrue(
            TabletomeLayout.usesPairedPlayerColumns(
                horizontalSizeClass: .regular,
                verticalSizeClass: .compact
            )
        )
        XCTAssertTrue(
            TabletomeLayout.usesPairedPlayerColumns(
                horizontalSizeClass: .regular,
                verticalSizeClass: .regular
            )
        )
        XCTAssertFalse(
            TabletomeLayout.usesPairedPlayerColumns(
                horizontalSizeClass: .compact,
                verticalSizeClass: .regular
            )
        )
        XCTAssertFalse(
            TabletomeLayout.usesPairedPlayerColumns(
                horizontalSizeClass: .regular,
                verticalSizeClass: .compact,
                isAccessibilitySize: true
            )
        )
    }

    func testContextProperties() {
        XCTAssertTrue(TabletomeLayoutContext.shortHeight.isShortHeight)
        XCTAssertTrue(TabletomeLayoutContext.regular.usesSplitNavigation)
        XCTAssertFalse(TabletomeLayoutContext.compact.usesSplitNavigation)
    }
}
