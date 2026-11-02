import XCTest
@testable import MiniBuddy
@testable import MiniBuddyDomain

@MainActor
final class SpearheadBattleNowContentTests: XCTestCase {
    func testPlannerShowsHelpersOnlyForThatPhase() {
        XCTAssertEqual(
            BattleNowPlanner.blocks(phase: .hero, abilityCount: 0, armyPickCount: 0, showsAllAbilities: false),
            [.empty]
        )
        XCTAssertEqual(
            BattleNowPlanner.blocks(phase: .charge, abilityCount: 1, armyPickCount: 0, showsAllAbilities: false),
            [.abilities]
        )
        XCTAssertEqual(
            BattleNowPlanner.blocks(phase: .movement, abilityCount: 0, armyPickCount: 1, showsAllAbilities: false),
            [.armyPicks, .movement]
        )
        XCTAssertEqual(
            BattleNowPlanner.blocks(phase: .shooting, abilityCount: 2, armyPickCount: 0, showsAllAbilities: false),
            [.abilities, .shooting]
        )
        XCTAssertEqual(
            BattleNowPlanner.blocks(phase: .combat, abilityCount: 0, armyPickCount: 0, showsAllAbilities: false),
            [.combat]
        )
        XCTAssertEqual(
            BattleNowPlanner.blocks(phase: .endOfTurn, abilityCount: 1, armyPickCount: 0, showsAllAbilities: false),
            [.scoring, .abilities]
        )
        XCTAssertEqual(
            BattleNowPlanner.blocks(phase: .hero, abilityCount: 0, armyPickCount: 0, showsAllAbilities: true),
            [.abilities]
        )
    }

    func testNowAbilitiesFollowTheCurrentPhase() {
        let viewModel = makeViewModel(phase: .hero)
        XCTAssertEqual(viewModel.nowAbilities.map(\.name), ["Arcane Bolt"])

        viewModel.trackerState.currentPhase = .shooting
        XCTAssertEqual(viewModel.nowAbilities.map(\.name), ["Volley"])

        viewModel.trackerState.currentPhase = .hero
        viewModel.toggleShowAllAbilities()
        XCTAssertEqual(Set(viewModel.nowAbilities.map(\.name)), ["Arcane Bolt", "Volley"])
    }

    func testStartOfRoundAbilitiesStayOffThePhaseList() {
        let viewModel = makeViewModel(phase: .hero)
        XCTAssertFalse(viewModel.nowAbilities.contains { $0.name == "Rally" })
        viewModel.toggleShowAllAbilities()
        XCTAssertFalse(viewModel.nowAbilities.contains { $0.name == "Rally" })
    }

    func testMarkingAnAbilityUsedUpdatesImmediately() {
        let viewModel = makeViewModel(phase: .hero)
        guard let ability = viewModel.nowAbilities.first(where: { $0.name == "Arcane Bolt" }) else {
            XCTFail("Missing hero ability")
            return
        }
        XCTAssertFalse(viewModel.isAbilityUsed(ability))
        viewModel.markAbilityUsed(ability)
        XCTAssertTrue(viewModel.isAbilityUsed(ability))
        XCTAssertEqual(viewModel.nowAbilities.map(\.name), ["Arcane Bolt"])
    }

    func testArmyPicksAppearOnlyInTheirPhase() {
        let viewModel = makeViewModel(phase: .movement)
        XCTAssertEqual(viewModel.phaseArmyRuleOptions.map(\.id), ["reg-move"])

        viewModel.trackerState.currentPhase = .hero
        XCTAssertTrue(viewModel.phaseArmyRuleOptions.isEmpty)
    }

    private func makeViewModel(phase: BattleTurnPhase) -> SpearheadBattleViewModel {
        let hero = TriggeredAbility(
            id: "hero-spell",
            name: "Arcane Bolt",
            source: "Wizard",
            phases: [.hero],
            usageLimit: .oncePerBattle,
            effect: "Deal 1 damage."
        )
        let rally = TriggeredAbility(
            id: "rally",
            name: "Rally",
            source: "Wizard",
            phases: [.hero],
            usageLimit: .oncePerBattle,
            effect: "At the start of the battle round, heal 1."
        )
        let volley = TriggeredAbility(
            id: "volley",
            name: "Volley",
            source: "Archers",
            phases: [.shooting],
            usageLimit: .eachPhase,
            effect: "Shoot again."
        )
        let army = SpearheadArmy(
            id: "army-1",
            name: "Test Army",
            general: "General",
            tagline: "",
            playstyle: "",
            unitCount: 1,
            regimentAbilities: [
                ArmyRuleOption(
                    id: "reg-move",
                    name: "Swift",
                    summary: "Move farther.",
                    phases: [.movement]
                )
            ],
            units: [
                SpearheadUnit(
                    id: "unit-1",
                    name: "Wizard",
                    abilities: [hero, rally, volley]
                )
            ]
        )
        var match = GuidedMatchState()
        match.playerOne.playerName = "Alice"
        match.playerOne.armyId = army.id
        match.playerOne.regimentAbilityId = "reg-move"
        let catalog = SpearheadCatalog(
            schemaVersion: 1,
            factions: [
                SpearheadFaction(id: "faction", name: "Faction", alliance: .order, armies: [army])
            ],
            matchSteps: []
        )
        return SpearheadBattleViewModel(
            gameSystemId: .aosSpearhead,
            matchState: match,
            catalog: catalog,
            initialState: BattleTrackerState(activePlayerIsOne: true, currentPhase: phase)
        )
    }
}
