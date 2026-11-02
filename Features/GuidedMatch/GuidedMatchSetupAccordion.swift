import SwiftUI
import MiniBuddyDomain

struct SetupAccordion: View {
    @ObservedObject var viewModel: GuidedMatchViewModel
    let ruleSections: [RuleSection]
    let onStartBattle: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(BannerCenter.self) private var banners
    @State private var editingStepId: String?

    private var isShortHeight: Bool { verticalSizeClass == .compact }

    var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: isShortHeight ? DesignTokens.Spacing.xs : DesignTokens.Spacing.sm) {
                        ForEach(Array(viewModel.sortedMatchSteps.enumerated()), id: \.element.id) { index, step in
                            stepRow(step, number: index + 1)
                                .id(step.id)
                        }
                    }
                    .padding(isShortHeight ? DesignTokens.Spacing.sm : DesignTokens.Spacing.md)
                    .modifier(SetupAccordionReadableWidth(constrain: !isShortHeight))
                }
                progressBar
            }
            .onChange(of: viewModel.setupProgress.completed) { previous, completed in
                guard completed > previous else { return }
                if viewModel.setupIsComplete {
                    editingStepId = nil
                    banners.show(
                        BannerItem(
                            id: "guidedMatch.setupComplete",
                            message: String(localized: "Setup complete. Ready to battle."),
                            systemImage: "checkmark.circle.fill",
                            tone: .success
                        )
                    )
                } else if let next = viewModel.nextIncompleteStep {
                    editingStepId = nil
                    withAnimation(TTMotion.standard(reduceMotion: reduceMotion)) {
                        proxy.scrollTo(next.id, anchor: .top)
                    }
                }
            }
        }
        .ttHaptic(.phaseAdvanced, trigger: viewModel.setupProgress.completed)
        .ttScreenBackground()
    }

    private var progressBar: some View {
        let progress = viewModel.setupProgress
        return HStack(spacing: isShortHeight ? DesignTokens.Spacing.sm : DesignTokens.Spacing.md) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                TTProgressBar(fraction: viewModel.setupProgressFraction, tone: .brand, criticalThreshold: nil)
                Text(String(localized: "\(progress.completed) of \(progress.total) steps"))
                    .font(isShortHeight ? TTFont.caption : TTFont.footnote)
                    .foregroundStyle(TTColor.inkSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Button(String(localized: "Start Battle"), action: onStartBattle)
                .buttonStyle(.ttPrimaryInline)
                .controlSize(isShortHeight ? .small : .regular)
                .disabled(!viewModel.setupIsComplete)
                .accessibilityIdentifier("guidedMatch.startBattle")
        }
        .padding(isShortHeight ? 0 : DesignTokens.Spacing.md)
        .barChromeBackground(
            horizontalPadding: DesignTokens.Spacing.md,
            verticalPadding: isShortHeight ? DesignTokens.Spacing.xxs : DesignTokens.Spacing.sm
        )
    }

    @ViewBuilder
    private func stepRow(_ step: MatchSetupStep, number: Int) -> some View {
        let done = viewModel.matchState.completedStepIds.contains(step.id)
        let expanded = expandedStepId == step.id
        if expanded {
            currentCard(step, number: number)
        } else if done {
            doneRow(step, number: number)
        } else {
            upcomingRow(step, number: number)
        }
    }

    private var expandedStepId: String? {
        if let editingStepId { return editingStepId }
        return viewModel.nextIncompleteStep?.id
    }

    private func doneRow(_ step: MatchSetupStep, number: Int) -> some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(TTColor.success)
                .accessibilityHidden(true)
            Text(step.title)
                .font(TTFont.headline)
                .foregroundStyle(TTColor.inkSecondary)
            Spacer(minLength: 0)
            Button(String(localized: "Edit")) {
                withAnimation(TTMotion.standard(reduceMotion: reduceMotion)) {
                    editingStepId = step.id
                }
            }
            .buttonStyle(.ttTertiary)
        }
        .frame(minHeight: isShortHeight ? DesignTokens.minTouchTarget : 52)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("guidedMatch.setupStep.\(step.id)")
        .accessibilityLabel(String(localized: "Step \(number), \(step.title), complete"))
    }

    private func currentCard(_ step: MatchSetupStep, number: Int) -> some View {
        VStack(alignment: .leading, spacing: isShortHeight ? DesignTokens.Spacing.xs : DesignTokens.Spacing.sm) {
            HStack(alignment: .firstTextBaseline, spacing: DesignTokens.Spacing.sm) {
                Text("\(number)")
                    .font(TTFont.numericSmall)
                    .foregroundStyle(TTColor.inkOnBrand)
                    .frame(width: 28, height: 28)
                    .background(TTColor.brandFill, in: Circle())
                Text(step.title)
                    .font(TTFont.titleSmall)
                    .foregroundStyle(TTColor.inkPrimary)
            }
            Text(step.summary)
                .font(TTFont.callout)
                .foregroundStyle(TTColor.inkSecondary)
                .lineLimit(2)
            MatchStepDetailView(
                step: step,
                stepNumber: number,
                viewModel: viewModel,
                ruleSections: ruleSections,
                presentation: .inlineHub
            )
            NavigationLink(value: GuidedMatchDestination.step(step.id)) {
                Text(String(localized: "Read full step"))
            }
            .buttonStyle(.ttTertiary)
            .accessibilityIdentifier("guidedMatch.stepGuide.\(step.id)")
        }
        .surfaceCard(padding: isShortHeight ? DesignTokens.Spacing.sm : DesignTokens.Spacing.md)
        .accessibilityIdentifier("guidedMatch.setupStep.\(step.id)")
    }

    private func upcomingRow(_ step: MatchSetupStep, number: Int) -> some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Text("\(number)")
                .font(TTFont.numericSmall)
                .foregroundStyle(TTColor.inkTertiary)
                .frame(width: 28, height: 28)
                .overlay {
                    Circle().strokeBorder(TTColor.stroke, lineWidth: 2)
                }
            Text(step.title)
                .font(TTFont.headline)
                .foregroundStyle(TTColor.inkTertiary)
            Spacer(minLength: 0)
        }
        .frame(minHeight: isShortHeight ? DesignTokens.minTouchTarget : 52)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("guidedMatch.setupStep.\(step.id)")
        .accessibilityLabel(String(localized: "Step \(number), \(step.title), not started"))
    }
}

/// Landscape already has little height; a 560pt column wastes the width that paired player cards need.
private struct SetupAccordionReadableWidth: ViewModifier {
    var constrain: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        if constrain {
            content.readableContentWidth()
        } else {
            content
        }
    }
}
