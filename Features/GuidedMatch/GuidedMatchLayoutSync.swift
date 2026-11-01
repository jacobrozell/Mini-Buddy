import Foundation

enum GuidedMatchLayoutSync {
    static func hubTab(for destination: GuidedMatchDestination?, current: GuidedMatchHubTab) -> GuidedMatchHubTab {
        switch destination {
        case .battleTracker: .battle
        case .step: .setup
        case .playerOne, .playerTwo: .armies
        case nil: current
        }
    }

    static func destination(
        for hubTab: GuidedMatchHubTab,
        showsBattle: Bool,
        nextIncompleteStepId: String?,
        current: GuidedMatchDestination?
    ) -> GuidedMatchDestination? {
        switch hubTab {
        case .battle where showsBattle: .battleTracker
        case .setup: nextIncompleteStepId.map(GuidedMatchDestination.step) ?? current
        default: current
        }
    }
}
