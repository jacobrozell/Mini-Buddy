import SwiftUI
import TabletomeDomain

struct ShootingEligibleUnitsCard: View {
    let units: [SpearheadUnit]
    let armyName: String
    var onSelectUnit: ((String) -> Void)?

    init(
        units: [SpearheadUnit],
        armyName: String,
        gameSystemId _: GameSystemId = .default,
        onSelectUnit: ((String) -> Void)? = nil
    ) {
        self.units = units
        self.armyName = armyName
        self.onSelectUnit = onSelectUnit
    }

    init(
        units: [SpearheadUnit],
        armyName: String,
        gameSystemId: String,
        onSelectUnit: ((String) -> Void)? = nil
    ) {
        self.init(
            units: units,
            armyName: armyName,
            gameSystemId: GameSystemId(resolving: gameSystemId),
            onSelectUnit: onSelectUnit
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            TTSectionHeader(String(localized: "Can Shoot"))
            if units.isEmpty {
                Text(String(localized: "No ranged weapons in this army."))
                    .font(TTFont.callout)
                    .foregroundStyle(TTColor.inkSecondary)
            } else {
                VStack(spacing: DesignTokens.Spacing.xs) {
                    ForEach(units) { unit in
                        shootingUnitRow(unit)
                    }
                }
            }
        }
        .accessibilityIdentifier("battleTracker.shootingEligible")
        .accessibilityLabel(String(localized: "Can shoot, \(armyName)"))
    }

    @ViewBuilder
    private func shootingUnitRow(_ unit: SpearheadUnit) -> some View {
        let weaponNames = unit.shootingWeapons.map(\.name).joined(separator: ", ")
        if let onSelectUnit {
            Button {
                onSelectUnit(unit.id)
            } label: {
                rowLabel(unit: unit, weaponNames: weaponNames)
            }
            .buttonStyle(.plain)
            .frame(minHeight: DesignTokens.minTouchTarget)
            .accessibilityHint(String(localized: "Opens the dice sheet"))
            .accessibilityIdentifier("battleTracker.shootingEligible.\(unit.id)")
        } else {
            rowLabel(unit: unit, weaponNames: weaponNames)
        }
    }

    private func rowLabel(unit: SpearheadUnit, weaponNames: String) -> some View {
        let count = unit.shootingWeapons.count
        let countLabel = count == 1
            ? String(localized: "1 weapon")
            : String(localized: "\(count) weapons")
        return TTRow(
            title: unit.name,
            subtitle: weaponNames.isEmpty ? countLabel : "\(countLabel) · \(weaponNames)",
            systemImage: "scope",
            tone: .brand,
            accessory: .none
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
