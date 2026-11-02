import SwiftUI
import TabletomeDomain

/// Phase content for the Spearhead battle screen: header, abilities for this phase, and that phase's helpers.
struct BattleNowPanel<Extras: View>: View {
    @ObservedObject var viewModel: SpearheadBattleViewModel
    @Binding var movementAction: MovementAction
    var showsPileIn: Bool
    let onResolveAbility: (TriggeredAbility) -> Void
    let onSelectShootingUnit: (String) -> Void
    let onSelectCombatShooter: (String, String) -> Void
    @ViewBuilder var extras: () -> Extras

    @State private var showsInstruction = false

    private var phase: BattleTurnPhase { viewModel.trackerState.currentPhase }

    private var blocks: [BattleNowBlock] {
        BattleNowPlanner.blocks(
            phase: phase,
            abilityCount: viewModel.nowAbilities.count,
            armyPickCount: viewModel.phaseArmyRuleOptions.count,
            showsAllAbilities: viewModel.trackerState.showAllAbilities
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            header
            instruction
            if blocks.contains(.scoring) {
                endOfTurnScoring
            }
            if blocks.contains(.abilities) {
                abilitiesSection
            }
            if blocks.contains(.armyPicks) {
                armyPicksSection
            }
            if blocks.contains(.movement) {
                movementSection
            }
            if blocks.contains(.shooting) {
                shootingSection
            }
            if blocks.contains(.combat) {
                combatSection
            }
            if blocks.contains(.empty) {
                emptyPhase
            }
            extras()
            showAllButton
        }
        .accessibilityIdentifier("battleTracker.now")
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text(eyebrow)
                .ttEyebrow(TTTone.player(viewModel.trackerState.activePlayerIsOne).foreground)
            Text(phase.battleHeadline)
                .font(TTFont.title)
                .foregroundStyle(TTColor.inkPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("battleTracker.now.header")
    }

    private var eyebrow: String {
        if viewModel.trackerState.showAllAbilities {
            return String(localized: "All abilities")
        }
        return String(localized: "\(viewModel.activePlayerName)'s turn · \(phase.title)")
    }

    @ViewBuilder
    private var instruction: some View {
        let summary = viewModel.currentGuideStep?.instruction ?? ""
        let detail = phase.playerFacingSummary(gameSystemId: viewModel.gameSystemId.rawValue)
        if !summary.isEmpty || !detail.isEmpty {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                if !summary.isEmpty {
                    Text(summary)
                        .font(TTFont.callout)
                        .foregroundStyle(TTColor.inkSecondary)
                        .lineLimit(showsInstruction ? nil : 2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                if showsInstruction, !detail.isEmpty, detail != summary {
                    Text(detail)
                        .font(TTFont.footnote)
                        .foregroundStyle(TTColor.inkSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Button(showsInstruction ? String(localized: "Less") : String(localized: "More")) {
                    showsInstruction.toggle()
                }
                .buttonStyle(.ttTertiary)
                .frame(minHeight: DesignTokens.minTouchTarget, alignment: .leading)
                .accessibilityHint(String(localized: "Shows the full phase instructions"))
                .accessibilityIdentifier("battleTracker.now.more")
            }
        }
    }

    private var endOfTurnScoring: some View {
        let scoring = viewModel.playContext.victoryPointsScoring
        let isOne = viewModel.trackerState.activePlayerIsOne
        return VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            TTCounter(
                value: activeVictoryPoints,
                range: 0...999,
                label: String(localized: "\(viewModel.activePlayerName) victory points"),
                tone: .player(isOne),
                size: .large
            )
            .accessibilityIdentifier("battleTracker.now.victoryPoints")
            Button(scoring.primaryQuickAddLabel) {
                viewModel.adjustVictoryPoints(
                    playerIsOne: isOne,
                    delta: scoring.primaryQuickAddAmount,
                    reason: .objective
                )
            }
            .buttonStyle(.ttSecondary)
            .accessibilityIdentifier("battleTracker.now.objective")
            Button(scoring.secondaryQuickAddLabel) {
                viewModel.adjustVictoryPoints(
                    playerIsOne: isOne,
                    delta: scoring.secondaryQuickAddAmount,
                    reason: .tactic
                )
            }
            .buttonStyle(.ttSecondary)
            .accessibilityIdentifier("battleTracker.now.tactic")
        }
    }

    private var activeVictoryPoints: Binding<Int> {
        Binding(
            get: {
                viewModel.trackerState.activePlayerIsOne
                    ? viewModel.trackerState.playerOneVictoryPoints
                    : viewModel.trackerState.playerTwoVictoryPoints
            },
            set: { newValue in
                let isOne = viewModel.trackerState.activePlayerIsOne
                let current = isOne
                    ? viewModel.trackerState.playerOneVictoryPoints
                    : viewModel.trackerState.playerTwoVictoryPoints
                let delta = newValue - current
                guard delta != 0 else { return }
                viewModel.adjustVictoryPoints(playerIsOne: isOne, delta: delta, reason: .manual)
            }
        )
    }

    private var abilitiesSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            TTSectionHeader(String(localized: "Use Now (\(viewModel.nowAbilities.count))"))
            if viewModel.nowAbilities.isEmpty {
                Text(String(localized: "No abilities on this army."))
                    .font(TTFont.callout)
                    .foregroundStyle(TTColor.inkSecondary)
            } else {
                ForEach(viewModel.nowAbilities) { ability in
                    UnitAbilityCard(
                        ability: ability,
                        phase: phase,
                        isUsed: viewModel.isAbilityUsed(ability),
                        onMarkUsed: ability.usageLimit == .oncePerBattle
                            ? { viewModel.markAbilityUsed(ability) }
                            : nil,
                        gameSystemId: viewModel.gameSystemId.rawValue,
                        showsEmbeddedCombatTools: true,
                        onResolveAttack: { onResolveAbility(ability) }
                    )
                }
            }
        }
        .accessibilityIdentifier("battleTracker.now.abilities")
    }

    private var armyPicksSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            TTSectionHeader(String(localized: "Army Picks"))
            ForEach(viewModel.phaseArmyRuleOptions) { option in
                ArmyRuleOptionCard(
                    option: option,
                    isSelected: true,
                    gameSystemId: viewModel.gameSystemId.rawValue
                )
            }
        }
        .accessibilityIdentifier("battleTracker.now.armyPicks")
    }

    private var movementSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            MovementActionPicker(
                action: $movementAction,
                gameSystemId: viewModel.gameSystemId.rawValue
            )
            MovementRangeCard(
                playerName: viewModel.activePlayerName,
                army: viewModel.activeArmy,
                woundsRemaining: viewModel.trackerState.unitWoundsRemaining,
                armyId: viewModel.activeArmy?.id
            )
        }
    }

    @ViewBuilder
    private var shootingSection: some View {
        if ReleaseSurface.showsCombatResolver(for: viewModel.gameSystemId) {
            ShootingEligibleUnitsCard(
                units: viewModel.shootingEligibleUnits,
                armyName: viewModel.activeArmy?.name ?? viewModel.activePlayerName,
                gameSystemId: viewModel.gameSystemId,
                onSelectUnit: onSelectShootingUnit
            )
        }
    }

    @ViewBuilder
    private var combatSection: some View {
        if showsPileIn {
            PileInGuideCard()
        }
        if ReleaseSurface.showsCombatResolver(for: viewModel.gameSystemId),
           !viewModel.shootInCombatEligibleUnits.isEmpty {
            ShootInCombatEligibleUnitsCard(
                units: viewModel.shootInCombatEligibleUnits,
                onSelectUnit: onSelectCombatShooter
            )
        }
    }

    private var emptyPhase: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            Image(systemName: phase.battleSystemImage)
                .font(TTFont.title)
                .foregroundStyle(TTColor.inkTertiary)
                .accessibilityHidden(true)
            Text(phase.battleHeadline)
                .font(TTFont.headline)
                .foregroundStyle(TTColor.inkPrimary)
            Text(phase.nowEmptyDetail)
                .font(TTFont.callout)
                .foregroundStyle(TTColor.inkSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("battleTracker.now.empty")
    }

    private var showAllButton: some View {
        Button(
            viewModel.trackerState.showAllAbilities
                ? String(localized: "Show this phase only")
                : String(localized: "Show all abilities")
        ) {
            viewModel.toggleShowAllAbilities()
        }
        .buttonStyle(.ttTertiary)
        .frame(minHeight: DesignTokens.minTouchTarget, alignment: .leading)
        .accessibilityIdentifier("battleTracker.now.showAll")
    }
}
