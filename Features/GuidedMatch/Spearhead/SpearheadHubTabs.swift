import Foundation
import MiniBuddyDomain

/// Spearhead hub tab policy (§15 / plan §6.1) — wraps `GuidedMatchHubTab` with starter-matchup rules.
enum SpearheadHubTabs {
    typealias Tab = GuidedMatchHubTab

    /// Before starter matchup: **Armies** only. After: **Setup** + **Battle** (no empty Armies tab).
    static func visibleTabs(hasBothArmies: Bool) -> [Tab] {
        GuidedMatchHubTab.visibleTabs(gameSystemId: .aosSpearhead, hasBothArmies: hasBothArmies)
    }

    static func suggested(hasBothArmies: Bool, setupComplete: Bool) -> Tab {
        GuidedMatchHubTab.suggested(
            gameSystemId: .aosSpearhead,
            hasBothArmies: hasBothArmies,
            setupComplete: setupComplete
        )
    }

    static func padDetailDestination(
        hasBothArmies: Bool,
        setupComplete: Bool,
        nextIncompleteStepId: String?
    ) -> GuidedMatchDestination? {
        guard hasBothArmies else { return nil }
        if setupComplete {
            return .battleTracker
        }
        if let nextIncompleteStepId {
            return .step(nextIncompleteStepId)
        }
        return .battleTracker
    }
}
