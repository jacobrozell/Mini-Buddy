import TabletomeDomain

/// Which blocks the Spearhead Now panel renders for a phase. Header, instruction, and the show-all control are always present.
enum BattleNowBlock: String, Equatable {
    case scoring
    case abilities
    case armyPicks
    case movement
    case shooting
    case combat
    case empty
}

enum BattleNowPlanner {
    static func blocks(
        phase: BattleTurnPhase,
        abilityCount: Int,
        armyPickCount: Int,
        showsAllAbilities: Bool
    ) -> [BattleNowBlock] {
        var blocks: [BattleNowBlock] = []
        if phase == .endOfTurn || phase == .endOfAnyTurn {
            blocks.append(.scoring)
        }
        if abilityCount > 0 || showsAllAbilities {
            blocks.append(.abilities)
        }
        if armyPickCount > 0 {
            blocks.append(.armyPicks)
        }
        switch phase {
        case .movement:
            blocks.append(.movement)
        case .shooting:
            blocks.append(.shooting)
        case .combat, .anyCombat:
            blocks.append(.combat)
        default:
            break
        }
        let hasHelper = blocks.contains(.movement) || blocks.contains(.shooting) || blocks.contains(.combat)
        let hasScoring = blocks.contains(.scoring)
        if abilityCount == 0, armyPickCount == 0, !showsAllAbilities, !hasHelper, !hasScoring {
            blocks.append(.empty)
        }
        return blocks
    }
}
