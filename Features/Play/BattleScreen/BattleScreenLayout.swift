import SwiftUI

/// Five-slot battle frame: scoreboard, phase rail, now panel, action bar, and an iPad side panel.
struct BattleScreenLayout<Scoreboard: View, PhaseRail: View, Content: View, ActionBar: View, SidePanel: View>: View {
    let layoutContext: MiniBuddyLayoutContext
    var dynamicTypeSize: DynamicTypeSize
    @ViewBuilder var scoreboard: (BattleScreenArrangement) -> Scoreboard
    @ViewBuilder var phaseRail: (BattleScreenArrangement) -> PhaseRail
    @ViewBuilder var content: () -> Content
    @ViewBuilder var actionBar: () -> ActionBar
    @ViewBuilder var sidePanel: () -> SidePanel

    var body: some View {
        GeometryReader { proxy in
            let arrangement = BattleScreenArrangement.resolve(
                context: layoutContext,
                containerSize: proxy.size,
                needsLayoutAdaptation: dynamicTypeSize.needsLayoutAdaptation
            )
            Group {
                switch arrangement {
                case .stacked:
                    stacked
                        .accessibilityIdentifier("battleScreen.layout.stacked")
                case .twoColumn:
                    twoColumn(width: proxy.size.width)
                        .accessibilityIdentifier("battleScreen.layout.twoColumn")
                case .wide:
                    wide(width: proxy.size.width)
                        .accessibilityIdentifier("battleScreen.layout.wide")
                }
            }
            .accessibilityElement(children: .contain)
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .topLeading)
        }
    }

    private var stacked: some View {
        VStack(spacing: 0) {
            scoreboard(.stacked)
            phaseRail(.stacked)
            ScrollView {
                content()
                    .padding(DesignTokens.Spacing.md)
                    .readableContentWidth()
            }
            actionBar()
        }
    }

    private func twoColumn(width: CGFloat) -> some View {
        HStack(spacing: 0) {
            ScrollView {
                scoreboard(.twoColumn)
            }
            .scrollBounceBehavior(.basedOnSize)
            .frame(width: BattleScreenArrangement.sidebarWidth(containerWidth: width))
            .background(TTColor.surface.ignoresSafeArea(edges: [.leading, .bottom]))
            .overlay(alignment: .trailing) {
                Rectangle().fill(TTColor.stroke).frame(width: 1)
            }
            VStack(spacing: 0) {
                phaseRail(.twoColumn)
                ScrollView {
                    content()
                        .padding(DesignTokens.phoneLandscapeHorizontalPadding)
                }
                actionBar()
            }
        }
    }

    private func wide(width: CGFloat) -> some View {
        VStack(spacing: 0) {
            scoreboard(.wide)
            phaseRail(.wide)
                .frame(maxWidth: 720)
            HStack(alignment: .top, spacing: DesignTokens.Spacing.lg) {
                VStack(spacing: 0) {
                    ScrollView {
                        content()
                            .padding(DesignTokens.Spacing.md)
                    }
                    actionBar()
                }
                .frame(width: BattleScreenArrangement.nowColumnWidth(containerWidth: width))
                ScrollView {
                    sidePanel()
                        .padding(DesignTokens.Spacing.md)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
