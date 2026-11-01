import SwiftUI
import TabletomeDomain

struct SpearheadPreBattleLoadoutStep: View {
    @ObservedObject var viewModel: GuidedMatchViewModel
    let parts: GuidedMatchStepParts
    let ruleSections: [RuleSection]

    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State private var showsLoadoutSheet = false

    private var isShortHeight: Bool { verticalSizeClass == .compact }

    var body: some View {
        VStack(alignment: .leading, spacing: isShortHeight ? DesignTokens.Spacing.sm : DesignTokens.Spacing.lg) {
            coachingCallouts
            parts.recommendedDefaultsControls()

            Button {
                showsLoadoutSheet = true
            } label: {
                Label(String(localized: "Set Loadout"), systemImage: "tray.and.arrow.down.fill")
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityIdentifier("guidedMatch.preBattleLoadout.openSheet")

            parts.spearheadBattleTacticsSection()

            if viewModel.eitherArmyHasSecondaryObjectives {
                parts.armyOptionsSection(
                    title: String(localized: "Secondary Objectives"),
                    playerOneKeyPath: \.secondaryObjectiveId,
                    playerTwoKeyPath: \.secondaryObjectiveId,
                    options: { army in army.secondaryObjectives },
                    onSelect: viewModel.setSecondaryObjective
                )
            }

            parts.loadoutSummarySection(
                showRegiment: true,
                showEnhancement: true,
                showSecondary: viewModel.eitherArmyHasSecondaryObjectives
            )
        }
        .sheet(isPresented: $showsLoadoutSheet) {
            SpearheadLoadoutSheet(
                viewModel: viewModel,
                ruleSections: ruleSections,
                onConfirm: {
                    viewModel.setStepComplete(SpearheadSetupStepId.preBattleLoadout, complete: true)
                }
            )
        }
    }

    @ViewBuilder
    private var coachingCallouts: some View {
        if isShortHeight {
            HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
                parts.regimentAbilityCoachingCallout()
                parts.enhancementCoachingCallout()
            }
        } else {
            parts.regimentAbilityCoachingCallout()
            parts.enhancementCoachingCallout()
        }
    }
}
