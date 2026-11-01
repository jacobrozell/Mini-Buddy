import SwiftUI

public extension DesignTokens {
    /// Comfortable max line length for body content on iPad and landscape.
    static let readableContentMaxWidth: CGFloat = 680
}

private struct ReadableContentWidthModifier: ViewModifier {
    var measuresText: Bool
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    func body(content: Content) -> some View {
        let layoutContext = TabletomeLayout.context(
            horizontalSizeClass: horizontalSizeClass,
            verticalSizeClass: verticalSizeClass
        )
        switch layoutContext {
        case .regular:
            content
                .frame(maxWidth: DesignTokens.readableContentMaxWidth)
                .frame(maxWidth: .infinity)
        case .shortHeight where measuresText:
            content
                .frame(maxWidth: DesignTokens.readableContentMaxWidthPhoneLandscape)
                .frame(maxWidth: .infinity)
        case .shortHeight, .compact:
            content
        }
    }
}

public extension View {
    /// Centers content on iPad.
    /// Phone landscape stays full width so cards reach the side edges.
    /// Pass `measuresText: true` for long-form prose, which keeps a measure in landscape.
    /// Apply to inner scroll content, not to `Form` or `List` — constraining those
    /// containers narrows the scroll hit area to the centered column.
    func readableContentWidth(measuresText: Bool = false) -> some View {
        modifier(ReadableContentWidthModifier(measuresText: measuresText))
    }

    /// Small bottom pad so the last row is not flush with the floating tab bar.
    /// A full bar-height pad stacks on the tab bar safe area and leaves a blank band.
    @ViewBuilder
    func tabBarScrollInset(enabled: Bool = true, additionalBottom: CGFloat = 0) -> some View {
        if enabled {
            ttBottomScrollEdge()
                .padding(.bottom, DesignTokens.tabBarScrollBottomInset + additionalBottom)
                .background(TTColor.canvas)
        } else {
            self
        }
    }

    /// Bar material behind status / hub chrome rows, bleeding to the horizontal screen edges.
    @ViewBuilder
    func barChromeBackground(
        horizontalPadding: CGFloat = DesignTokens.Spacing.md,
        verticalPadding: CGFloat = DesignTokens.Spacing.sm
    ) -> some View {
        let chrome = padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .frame(maxWidth: .infinity, minHeight: DesignTokens.minTouchTarget, alignment: .leading)
        if #available(iOS 26.0, *) {
            chrome.background(.bar, ignoresSafeAreaEdges: .horizontal)
        } else {
            chrome
                .background(TTColor.surface.opacity(0.92), ignoresSafeAreaEdges: .horizontal)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(TTColor.stroke)
                        .frame(height: 1)
                }
        }
    }

    /// Breathing room above the phase dock when it is pinned below scroll content.
    func battleTrackerPhaseDockScrollInset() -> some View {
        contentMargins(.bottom, DesignTokens.battleTrackerPhaseDockScrollBottomInset, for: .scrollContent)
    }
}
