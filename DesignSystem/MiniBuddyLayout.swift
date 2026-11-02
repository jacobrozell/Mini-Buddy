import SwiftUI

public enum MiniBuddyLayoutContext: Equatable, Sendable {
    /// Compact width, regular height: iPhone portrait, Duo folded, narrow iPad windows.
    case compact
    /// Compact height: every iPhone in landscape (Pro Max reports regular width), Duo folded landscape.
    case shortHeight
    /// Regular width and height: iPad in either orientation, Duo open, wide windows.
    case regular

    public var isShortHeight: Bool { self == .shortHeight }

    public var usesSplitNavigation: Bool { self == .regular }
}

public enum MiniBuddyLayout {
    public static let compactContainerHeightThreshold: CGFloat = 740

    public static func context(
        horizontalSizeClass: UserInterfaceSizeClass?,
        verticalSizeClass: UserInterfaceSizeClass?
    ) -> MiniBuddyLayoutContext {
        if verticalSizeClass == .compact { return .shortHeight }
        if horizontalSizeClass == .regular { return .regular }
        return .compact
    }

    public static func usesSplitNavigation(
        horizontalSizeClass: UserInterfaceSizeClass?,
        verticalSizeClass: UserInterfaceSizeClass?,
        dynamicTypeSize: DynamicTypeSize = .large
    ) -> Bool {
        context(horizontalSizeClass: horizontalSizeClass, verticalSizeClass: verticalSizeClass) == .regular
            && !dynamicTypeSize.needsLayoutAdaptation
    }

    public static func usesSideBySideLayout(
        horizontalSizeClass: UserInterfaceSizeClass?,
        verticalSizeClass: UserInterfaceSizeClass?,
        isAccessibilitySize: Bool = false
    ) -> Bool {
        !isAccessibilitySize
            && context(horizontalSizeClass: horizontalSizeClass, verticalSizeClass: verticalSizeClass) == .regular
    }

    /// Two-player cards sit side by side on iPad and in landscape, where width is the available axis.
    public static func usesPairedPlayerColumns(
        horizontalSizeClass: UserInterfaceSizeClass?,
        verticalSizeClass: UserInterfaceSizeClass?,
        isAccessibilitySize: Bool = false
    ) -> Bool {
        if isAccessibilitySize { return false }
        switch context(horizontalSizeClass: horizontalSizeClass, verticalSizeClass: verticalSizeClass) {
        case .regular, .shortHeight: return true
        case .compact: return false
        }
    }

    public static func prefersCompactGuidedMatchChrome(
        _ context: MiniBuddyLayoutContext,
        containerHeight: CGFloat
    ) -> Bool {
        switch context {
        case .shortHeight: true
        case .compact: containerHeight > 0 && containerHeight <= compactContainerHeightThreshold
        case .regular: false
        }
    }
}

struct MiniBuddyLayoutReader<Content: View>: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @ViewBuilder let content: (_ context: MiniBuddyLayoutContext) -> Content

    var body: some View {
        content(
            MiniBuddyLayout.context(
                horizontalSizeClass: horizontalSizeClass,
                verticalSizeClass: verticalSizeClass
            )
        )
    }
}
