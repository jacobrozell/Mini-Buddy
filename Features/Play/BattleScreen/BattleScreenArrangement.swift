import SwiftUI

enum BattleScreenArrangement: Equatable {
    case stacked
    case twoColumn
    case wide

    static let wideMinimumWidth: CGFloat = 720
    static let wideMinimumHeight: CGFloat = 560

    static func resolve(
        context: MiniBuddyLayoutContext,
        containerSize: CGSize,
        needsLayoutAdaptation: Bool
    ) -> BattleScreenArrangement {
        if context == .shortHeight { return .twoColumn }
        if !needsLayoutAdaptation,
           containerSize.width >= wideMinimumWidth,
           containerSize.height >= wideMinimumHeight {
            return .wide
        }
        return .stacked
    }

    static func sidebarWidth(containerWidth: CGFloat) -> CGFloat {
        min(300, max(220, containerWidth * 0.30))
    }

    static func nowColumnWidth(containerWidth: CGFloat) -> CGFloat {
        min(520, max(380, containerWidth * 0.45))
    }
}
