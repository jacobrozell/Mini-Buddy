import SwiftUI
import TabletomeDomain

private enum SpearheadBattlePresentationKey: EnvironmentKey {
    static let defaultValue: SpearheadBattlePresentation? = nil
}

extension EnvironmentValues {
    var spearheadBattlePresentation: SpearheadBattlePresentation? {
        get { self[SpearheadBattlePresentationKey.self] }
        set { self[SpearheadBattlePresentationKey.self] = newValue }
    }
}

@Observable
@MainActor
final class SpearheadBattlePresentation {
    var showsCombatSheet = false
    var showsUnitsSheet = false
    var showsVictoryPointsSheet = false
    var showsRoundPicker = false
    var showsTurnHandoff = false
    var resolverContext: InlineResolverContext?
    var turnStartPlayerOneVP = 0
    var turnStartPlayerTwoVP = 0
}
