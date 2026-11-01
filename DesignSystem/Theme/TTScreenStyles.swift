import SwiftUI

private struct ToastBottomInsetKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}

public extension EnvironmentValues {
    var toastBottomInset: CGFloat {
        get { self[ToastBottomInsetKey.self] }
        set { self[ToastBottomInsetKey.self] = newValue }
    }
}

public extension View {
    func ttScreenBackground() -> some View {
        background(TTColor.canvas.ignoresSafeArea())
    }

    func ttGroupedList() -> some View {
        listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(TTColor.canvas.ignoresSafeArea())
            .listRowSeparatorTint(TTColor.stroke)
            .environment(\.defaultMinListRowHeight, 52)
            .ttBottomScrollEdge()
    }

    func ttCardList() -> some View {
        listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(TTColor.canvas.ignoresSafeArea())
            .contentMargins(.horizontal, DesignTokens.Spacing.md, for: .scrollContent)
            .contentMargins(.top, DesignTokens.Spacing.sm, for: .scrollContent)
    }

    func ttListRow() -> some View {
        listRowBackground(TTColor.surface)
    }

    /// Pins search to the drawer under the navigation bar.
    /// Default placement follows the horizontal size class and, on iOS 26, moves the
    /// field into the navigation-bar platter. UIKit then breaks constraints and skips
    /// search-bar placement callbacks when that size class changes (rotation, tab switch).
    func ttSearchable(
        text: Binding<String>,
        prompt: String,
        displayMode: SearchFieldPlacement.NavigationBarDrawerDisplayMode = .automatic
    ) -> some View {
        searchable(
            text: text,
            placement: .navigationBarDrawer(displayMode: displayMode),
            prompt: prompt
        )
    }

    /// Keeps the last visible line from showing through the floating tab bar.
    @ViewBuilder
    func ttBottomScrollEdge() -> some View {
        if #available(iOS 26.0, *) {
            scrollEdgeEffectStyle(.hard, for: .bottom)
        } else {
            self
        }
    }
}
