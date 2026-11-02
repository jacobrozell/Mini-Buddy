import Foundation
import TabletomeDomain

extension SpearheadBattleViewModel {
    /// Triggered abilities for the Now panel. Start-of-round abilities stay on the round-start moment.
    var nowAbilities: [TriggeredAbility] {
        guard let army = activeArmy else { return [] }
        let phase = trackerState.currentPhase
        let abilities = BattleAbilityCatalog.abilities(for: army).filter { ability in
            !ability.isPassive && !ability.isStartOfBattleRound
        }
        let visible = trackerState.showAllAbilities
            ? abilities
            : abilities.filter { $0.matches(phase: phase) }
        return visible.sorted { lhs, rhs in
            let source = lhs.source.localizedCaseInsensitiveCompare(rhs.source)
            if source == .orderedSame {
                return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
            }
            return source == .orderedAscending
        }
    }

    /// Chosen regiment ability and enhancement when they trigger in this phase.
    var phaseArmyRuleOptions: [ArmyRuleOption] {
        guard let army = activeArmy else { return [] }
        let player = trackerState.activePlayerIsOne ? matchState.playerOne : matchState.playerTwo
        var options: [ArmyRuleOption] = []
        if let regiment = army.regimentAbilities.first(where: { $0.id == player.regimentAbilityId }),
           regiment.isAvailableIn(phase: trackerState.currentPhase) {
            options.append(regiment)
        }
        if let enhancement = army.enhancements.first(where: { $0.id == player.enhancementId }),
           enhancement.isAvailableIn(phase: trackerState.currentPhase) {
            options.append(enhancement)
        }
        return options
    }

    func isAbilityUsed(_ ability: TriggeredAbility) -> Bool {
        trackerState.usedOncePerBattleAbilityIds.contains(ability.id)
    }

    func markAbilityUsed(_ ability: TriggeredAbility) {
        guard ability.usageLimit == .oncePerBattle else { return }
        var state = trackerState
        state.usedOncePerBattleAbilityIds.insert(ability.id)
        trackerState = state
        persist()
    }

    func toggleShowAllAbilities() {
        var state = trackerState
        state.showAllAbilities.toggle()
        trackerState = state
        persist()
    }
}
