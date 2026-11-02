import Foundation
import MiniBuddyDomain

enum GuidedMatchSetupStepsCaption {
    static func text(gameSystemId: GameSystemId, stepCount: Int) -> String {
        GameSystemPlayContext.context(for: gameSystemId).copy.setupStepsCaption(stepCount: stepCount)
    }
}
