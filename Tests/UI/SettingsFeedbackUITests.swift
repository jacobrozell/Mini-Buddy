import XCTest

final class SettingsFeedbackUITests: ModelsFlowUITestCase {
    func testFeedbackFormRequiresSummaryBeforeSending() throws {
        openSettingsTab()

        let feedbackLink = app.descendants(matching: .any).matching(identifier: "settings.feedbackForm").firstMatch
        if !feedbackLink.waitForExistence(timeout: 3) {
            app.swipeUp()
        }
        XCTAssertTrue(feedbackLink.waitForExistence(timeout: 8))
        feedbackLink.tap()

        let sendButton = app.buttons["feedback.send"]
        let itemField = app.textFields["feedback.specificItem"]
        XCTAssertTrue(itemField.waitForExistence(timeout: 8))
        itemField.tap()
        itemField.typeText("Paints")

        XCTAssertTrue(scrollUntilHittable(sendButton))
        XCTAssertFalse(sendButton.isEnabled)

        let summaryField = app.textFields["feedback.summary"]
        XCTAssertTrue(scrollUntilHittable(summaryField, towardBottom: false))
        summaryField.tap()
        summaryField.typeText("Add more filter presets")

        XCTAssertTrue(scrollUntilHittable(sendButton))
        waitForEnabled(sendButton, timeout: 8)
    }
}
