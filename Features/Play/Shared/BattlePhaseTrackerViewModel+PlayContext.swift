import Foundation
import MiniBuddyDomain

extension BattlePhaseTrackerViewModel {
    var activePlayerSelection: PlayerArmySelection {
        trackerState.activePlayerIsOne ? matchState.playerOne : matchState.playerTwo
    }

    var activeArmySelection: SpearheadArmy? {
        army(for: activePlayerSelection)
    }
}
