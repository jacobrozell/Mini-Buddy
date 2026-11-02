import MiniBuddyDomain

extension BattlePhaseTrackerView {
    func logStandaloneBattleTrackerOpenedIfNeeded() {
        guard !isEmbeddedInGuidedMatch else { return }
        MiniBuddyAnalytics.logger?.info(
            .guidedMatch,
            eventName: "battle_tracker_opened",
            message: "Battle tracker presented.",
            metadata: [
                "gameSystemId": viewModel.gameSystemId.rawValue,
                "source": "standalone",
                "embedded": "false",
                "battleRound": String(viewModel.trackerState.battleRound)
            ]
        )
    }
}
