import SwiftUI

struct BattleTurnHandoffView: View {
    let nextIsPlayerOne: Bool
    let nextName: String
    let previousName: String
    let round: Int
    let scoredThisTurn: Int
    let playerOneScore: Int
    let playerTwoScore: Int
    let playerOneName: String
    let playerTwoName: String
    let onStart: () -> Void
    let onBack: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @AccessibilityFocusState private var titleFocused: Bool
    @State private var tokenScale: CGFloat = 0.6

    private var usesCompactHeightLayout: Bool {
        verticalSizeClass == .compact
    }

    var body: some View {
        ScrollView {
            Group {
                if usesCompactHeightLayout {
                    compactHeightContent
                } else {
                    portraitContent
                }
            }
            .frame(maxWidth: .infinity)
            .containerRelativeFrame(.vertical) { length, _ in max(length, 320) }
            .padding(DesignTokens.Spacing.lg)
        }
        .scrollBounceBehavior(.basedOnSize)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(TTColor.canvas)
        .onAppear {
            titleFocused = true
            tokenScale = reduceMotion ? 1 : 0.6
            withAnimation(TTMotion.emphasis(reduceMotion: reduceMotion)) {
                tokenScale = 1
            }
        }
        .accessibilityIdentifier("battleTracker.handoff")
    }

    private var portraitContent: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            Spacer(minLength: DesignTokens.Spacing.lg)
            playerToken(size: 96)
            titleBlock
            scoreLines
            Spacer(minLength: DesignTokens.Spacing.lg)
            actionButtons(stacked: true)
        }
    }

    private var compactHeightContent: some View {
        HStack(alignment: .center, spacing: DesignTokens.Spacing.lg) {
            playerToken(size: 64)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                titleBlock
                scoreLines
                actionButtons(stacked: false)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func playerToken(size: CGFloat) -> some View {
        TTPlayerToken(isPlayerOne: nextIsPlayerOne, size: size, isActive: true)
            .scaleEffect(tokenScale)
            .accessibilityHidden(true)
    }

    private var titleBlock: some View {
        VStack(alignment: usesCompactHeightLayout ? .leading : .center, spacing: DesignTokens.Spacing.xs) {
            Text(String(localized: "\(nextName)'s turn"))
                .font(usesCompactHeightLayout ? TTFont.title : TTFont.display)
                .foregroundStyle(TTColor.player(nextIsPlayerOne))
                .multilineTextAlignment(usesCompactHeightLayout ? .leading : .center)
                .accessibilityFocused($titleFocused)
            Text(String(localized: "Round \(round) · Pass the device"))
                .font(TTFont.subheadline)
                .foregroundStyle(TTColor.inkSecondary)
        }
    }

    @ViewBuilder
    private var scoreLines: some View {
        if scoredThisTurn > 0 {
            Text(String(localized: "\(previousName) scored \(scoredThisTurn) this turn"))
                .font(TTFont.body)
                .foregroundStyle(TTColor.inkPrimary)
        }
        Text(String(localized: "Score: \(playerOneName) \(playerOneScore) – \(playerTwoScore) \(playerTwoName)"))
            .font(TTFont.footnote)
            .foregroundStyle(TTColor.inkSecondary)
    }

    @ViewBuilder
    private func actionButtons(stacked: Bool) -> some View {
        if stacked {
            Button(String(localized: "Start \(nextName)'s Turn"), action: onStart)
                .buttonStyle(.ttPlayer(isPlayerOne: nextIsPlayerOne))
                .accessibilityIdentifier("battleTracker.handoff.start")
            Button(String(localized: "Back to End of Turn"), action: onBack)
                .buttonStyle(.ttTertiary)
                .accessibilityIdentifier("battleTracker.handoff.back")
        } else {
            HStack(spacing: DesignTokens.Spacing.md) {
                Button(String(localized: "Back"), action: onBack)
                    .buttonStyle(.ttTertiary)
                    .accessibilityIdentifier("battleTracker.handoff.back")
                Button(String(localized: "Start Turn"), action: onStart)
                    .buttonStyle(.ttPlayer(isPlayerOne: nextIsPlayerOne))
                    .accessibilityIdentifier("battleTracker.handoff.start")
            }
        }
    }
}
