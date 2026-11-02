import SwiftUI
import MiniBuddyDomain

struct PileInGuideCard: View {
    @State private var showsDetail = false

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            TTNotice(
                title: String(localized: "Pile in"),
                message: String(localized: "Before you fight, move up to 3\" closer to the enemy."),
                systemImage: "arrow.down.right.circle",
                tone: .neutral,
                action: (String(localized: "More"), { showsDetail.toggle() }),
                onDismiss: NewPlayerTipsStore.hasDismissedPileInGuide
                    ? nil
                    : {
                        NewPlayerTipsStore.dismissPileInGuide()
                    }
            )
            if showsDetail {
                Text(
                    String(
                        localized: """
                        Models not already in base contact may each move up to 3\" toward the closest enemy \
                        and must end closer than they started. Units already in combat fight from where they are.
                        """
                    )
                )
                .font(TTFont.footnote)
                .foregroundStyle(TTColor.inkSecondary)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityIdentifier("battleTracker.pileInGuide")
    }
}

struct SeizingInitiativeCallout: View {
    var body: some View {
        HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
            Image(systemName: "info.circle.fill")
                .foregroundStyle(TTColor.warning)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(String(localized: "Seizing initiative"))
                    .font(.subheadline.weight(.semibold))
                Text(
                    String(
                        localized: """
                        The priority winner may choose to go second instead. That can block refreshing your \
                        battle tactic hand this round unless you are the underdog by 5+ VP.
                        """
                    )
                )
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(TTColor.warningSoft, in: RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
        .accessibilityIdentifier("battleTracker.seizingInitiative")
    }
}

struct NewMainTurnReminderBanner: View {
    let round: Int

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Label(String(localized: "New battle round"), systemImage: "sparkles")
                .font(.headline)
            Text(
                round == 1
                    ? String(
                        localized: """
                        Round 1: draw a twist card, then each player draws 3 battle tactic cards from the top \
                        of their shuffled deck (no mulligan). Each card is a tactic or a command — not both. \
                        Resolve start-of-round abilities before the first turn.
                        """
                    )
                    : String(
                        localized: """
                        Round \(round): draw a twist card, refresh battle tactic hands, then resolve any \
                        start-of-round abilities before the first turn. Use command abilities from your cards during the turn.
                        """
                    )
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
        }
        .surfaceCard()
        .accessibilityIdentifier("battleTracker.newMainTurnReminder")
    }
}

struct BattleTacticCommandGuideCard: View {
    @State private var isExpanded = false

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                Text(
                    String(
                        localized: """
                        Each battle tactic card has two options: complete the tactic at end of turn for +1 VP, or use the \
                        printed command ability during your turn. You cannot do both with the same card.
                        """
                    )
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

                Text(
                    String(
                        localized: """
                        Hero phase is a good time to read your three cards and decide whether to spend a command before you move or fight.
                        """
                    )
                )
                .font(.caption)
                .foregroundStyle(.tertiary)
                .fixedSize(horizontal: false, vertical: true)

                if !NewPlayerTipsStore.hasDismissedBattleTacticCommandGuide {
                    Button(String(localized: "Got it")) {
                        NewPlayerTipsStore.dismissBattleTacticCommandGuide()
                        isExpanded = false
                    }
                    .buttonStyle(.bordered)
                    .frame(minHeight: DesignTokens.minTouchTarget)
                    .accessibilityIdentifier("battleTracker.battleTacticCommandGuide.dismiss")
                }
            }
            .padding(.top, DesignTokens.Spacing.sm)
        } label: {
            Label(String(localized: "Battle tactic commands"), systemImage: "rectangle.on.rectangle.angled")
                .font(.subheadline.weight(.semibold))
        }
        .surfaceCard()
        .accessibilityIdentifier("battleTracker.battleTacticCommandGuide")
        .onAppear {
            isExpanded = !NewPlayerTipsStore.hasDismissedBattleTacticCommandGuide
        }
    }
}
