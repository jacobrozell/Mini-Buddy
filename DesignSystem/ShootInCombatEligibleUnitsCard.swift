import SwiftUI
import TabletomeDomain

struct ShootInCombatEligibleUnitsCard: View {
    let units: [SpearheadUnit]
    var onSelectUnit: ((String, String) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            TTSectionHeader(String(localized: "Shoot in Combat"))
            VStack(spacing: DesignTokens.Spacing.xs) {
                ForEach(units) { unit in
                    combatShootingUnitRow(unit)
                }
            }
        }
        .accessibilityIdentifier("battleTracker.shootInCombatEligible")
    }

    @ViewBuilder
    private func combatShootingUnitRow(_ unit: SpearheadUnit) -> some View {
        let weapons = unit.weapons.filter { $0.hasShootInCombat && $0.isRanged }
        let weaponNames = weapons.map(\.name).joined(separator: ", ")

        if let onSelectUnit, let weapon = weapons.first {
            Button {
                onSelectUnit(unit.id, weapon.id)
            } label: {
                rowLabel(unit: unit, weaponNames: weaponNames)
            }
            .buttonStyle(.plain)
            .frame(minHeight: DesignTokens.minTouchTarget)
            .accessibilityHint(String(localized: "Opens the dice sheet"))
            .accessibilityIdentifier("battleTracker.shootInCombatEligible.\(unit.id)")
        } else {
            rowLabel(unit: unit, weaponNames: weaponNames)
        }
    }

    private func rowLabel(unit: SpearheadUnit, weaponNames: String) -> some View {
        let count = unit.weapons.filter { $0.hasShootInCombat && $0.isRanged }.count
        let countLabel = count == 1
            ? String(localized: "1 weapon")
            : String(localized: "\(count) weapons")
        return TTRow(
            title: unit.name,
            subtitle: weaponNames.isEmpty ? countLabel : "\(countLabel) · \(weaponNames)",
            systemImage: "scope",
            tone: .warning,
            accessory: .none
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
