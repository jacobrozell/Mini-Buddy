import SwiftUI
import MiniBuddyDomain

enum MovementAction: String, CaseIterable, Identifiable {
    case normal
    case run
    case retreat

    var id: String { rawValue }

    var title: String {
        switch self {
        case .normal: String(localized: "Normal Move")
        case .run: String(localized: "Run")
        case .retreat: String(localized: "Retreat")
        }
    }

    var detail: String {
        switch self {
        case .normal:
            String(localized: "Move up to the unit's Move characteristic.")
        case .run:
            String(localized: "Extra distance. This unit cannot shoot or charge.")
        case .retreat:
            String(localized: "Leave combat. This unit cannot shoot or charge.")
        }
    }
}

struct MovementActionPicker: View {
    @Binding var action: MovementAction
    var gameSystemId: String = GameSystemId.aosSpearhead.rawValue

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            TTSegmentedControl(
                selection: $action,
                options: Array(MovementAction.allCases),
                title: \.title,
                accessibilityIdentifier: { "battleTracker.movementAction.\($0.rawValue)" }
            )
            .accessibilityIdentifier("battleTracker.movementAction")
            .accessibilityLabel(String(localized: "Movement type"))

            Text(action.detail)
                .font(TTFont.caption)
                .foregroundStyle(TTColor.inkSecondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            if action == .retreat,
               let retreatEntry = SpearheadRulesGlossary.entries.first(where: { $0.id == "retreat" }) {
                GlossaryChip(entry: retreatEntry, gameSystemId: gameSystemId)
            }
        }
        .accessibilityIdentifier("battleTracker.movementActionCard")
    }
}
