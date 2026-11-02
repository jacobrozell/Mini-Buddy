import SwiftUI
import MiniBuddyDomain

struct MovementRangeCard: View {
    let playerName: String
    let army: SpearheadArmy?
    let woundsRemaining: [String: Int]
    let armyId: String?

    private var livingUnits: [(SpearheadUnit, String?)] {
        guard let army else { return [] }
        return army.units.compactMap { unit in
            let key = UnitWoundTracker.unitKey(armyId: army.id, unitId: unit.id)
            if let remaining = woundsRemaining[key], remaining == 0 { return nil }
            return (unit, unit.move)
        }
    }

    var body: some View {
        if !livingUnits.isEmpty {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                TTSectionHeader(String(localized: "\(playerName)'s move"))
                VStack(spacing: DesignTokens.Spacing.xs) {
                    ForEach(livingUnits, id: \.0.id) { unit, move in
                        HStack {
                            Text(unit.name)
                                .font(TTFont.body)
                                .foregroundStyle(TTColor.inkPrimary)
                                .lineLimit(2)
                            Spacer(minLength: DesignTokens.Spacing.sm)
                            Text(moveLabel(move))
                                .font(TTFont.numericSmall)
                                .foregroundStyle(TTColor.inkPrimary)
                        }
                        .padding(.vertical, DesignTokens.Spacing.xxs)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(String(localized: "\(unit.name), move \(moveLabel(move))"))
                    }
                }
            }
            .accessibilityIdentifier("battleTracker.movementRanges")
        }
    }

    private func moveLabel(_ move: String?) -> String {
        guard let move, !move.isEmpty else {
            return String(localized: "See card")
        }
        if move.contains("\"") || move.contains("inch") {
            return move
        }
        return String(localized: "\(move)\"")
    }
}
