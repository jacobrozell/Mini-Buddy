import SwiftUI
import XCTest
@testable import MiniBuddy

final class MiniBuddyLayoutTests: XCTestCase {
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
        equals expected: MiniBuddyLayoutContext,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(
            MiniBuddyLayout.context(horizontalSizeClass: horizontal, verticalSizeClass: vertical),
            expected,
            file: file,
            line: line
        )
    }

    func testUsesSplitNavigationRequiresRegularRegular() {
        XCTAssertTrue(
            MiniBuddyLayout.usesSplitNavigation(
                horizontalSizeClass: .regular,
                verticalSizeClass: .regular
            )
        )
        XCTAssertFalse(
            MiniBuddyLayout.usesSplitNavigation(
                horizontalSizeClass: .regular,
                verticalSizeClass: .compact
            )
        )
        XCTAssertFalse(
            MiniBuddyLayout.usesSplitNavigation(
                horizontalSizeClass: .compact,
                verticalSizeClass: .regular
            )
        )
    }

    func testUsesSplitNavigationDisabledAtAccessibilitySizes() {
        XCTAssertFalse(
            MiniBuddyLayout.usesSplitNavigation(
                horizontalSizeClass: .regular,
                verticalSizeClass: .regular,
                dynamicTypeSize: .accessibility1
            )
        )
    }

    func testPrefersCompactGuidedMatchChrome() {
        XCTAssertTrue(MiniBuddyLayout.prefersCompactGuidedMatchChrome(.shortHeight, containerHeight: 400))
        XCTAssertFalse(MiniBuddyLayout.prefersCompactGuidedMatchChrome(.regular, containerHeight: 800))
        XCTAssertTrue(MiniBuddyLayout.prefersCompactGuidedMatchChrome(.compact, containerHeight: 667))
        XCTAssertFalse(MiniBuddyLayout.prefersCompactGuidedMatchChrome(.compact, containerHeight: 852))
        XCTAssertFalse(MiniBuddyLayout.prefersCompactGuidedMatchChrome(.compact, containerHeight: 0))
    }

    func testUsesSideBySideLayout() {
        XCTAssertTrue(
            MiniBuddyLayout.usesSideBySideLayout(
                horizontalSizeClass: .regular,
                verticalSizeClass: .regular
            )
        )
        XCTAssertFalse(
            MiniBuddyLayout.usesSideBySideLayout(
                horizontalSizeClass: .regular,
                verticalSizeClass: .compact
            )
        )
        XCTAssertFalse(
            MiniBuddyLayout.usesSideBySideLayout(
                horizontalSizeClass: .regular,
                verticalSizeClass: .regular,
                isAccessibilitySize: true
            )
        )
    }

    func testUsesPairedPlayerColumnsInLandscape() {
        XCTAssertTrue(
            MiniBuddyLayout.usesPairedPlayerColumns(
                horizontalSizeClass: .compact,
                verticalSizeClass: .compact
            )
        )
        XCTAssertTrue(
            MiniBuddyLayout.usesPairedPlayerColumns(
                horizontalSizeClass: .regular,
                verticalSizeClass: .compact
            )
        )
        XCTAssertTrue(
            MiniBuddyLayout.usesPairedPlayerColumns(
                horizontalSizeClass: .regular,
                verticalSizeClass: .regular
            )
        )
        XCTAssertFalse(
            MiniBuddyLayout.usesPairedPlayerColumns(
                horizontalSizeClass: .compact,
                verticalSizeClass: .regular
            )
        )
        XCTAssertFalse(
            MiniBuddyLayout.usesPairedPlayerColumns(
                horizontalSizeClass: .regular,
                verticalSizeClass: .compact,
                isAccessibilitySize: true
            )
        )
    }

    func testContextProperties() {
        XCTAssertTrue(MiniBuddyLayoutContext.shortHeight.isShortHeight)
        XCTAssertTrue(MiniBuddyLayoutContext.regular.usesSplitNavigation)
        XCTAssertFalse(MiniBuddyLayoutContext.compact.usesSplitNavigation)
    }
}
