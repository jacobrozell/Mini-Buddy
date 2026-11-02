import XCTest
@testable import MiniBuddyDomain

final class HobbySourceMatchTests: XCTestCase {
    func testPartsSplitsTrimmedLowercased() {
        XCTAssertEqual(SourceMatch.parts("Spearhead Stormcast + Skaventide"),
                       ["spearhead stormcast", "skaventide"])
    }

    func testMatchesViaSubstringEitherDirection() {
        XCTAssertTrue(SourceMatch.matches("Skaventide", "Skaventide Box"))
        XCTAssertTrue(SourceMatch.matches("Skaventide Box", "Skaventide"))
    }

    func testEmptyUnitSourceNeverMatches() {
        XCTAssertFalse(SourceMatch.matches("Skaventide", ""))
    }
}
