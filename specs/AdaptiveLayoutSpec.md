# Adaptive layout (size classes, resizable iPad, iPhone Duo)

**Status:** 1.0.0 release surface  
**Last updated:** 2026-10-31

## Contexts

| Context | Size classes | Typical devices |
|---------|--------------|-----------------|
| `compact` | compact width, regular height | iPhone portrait, Duo folded, narrow iPad window |
| `shortHeight` | compact height (any width) | iPhone landscape (incl. Pro Max), Duo folded landscape |
| `regular` | regular width and height | iPad full screen, Duo open, wide Stage Manager window |

Source: [`DesignSystem/TabletomeLayout.swift`](../DesignSystem/TabletomeLayout.swift) — `TabletomeLayout.context(horizontalSizeClass:verticalSizeClass:)`.

## Shell rules

- **Tabs:** `AdaptiveTabStyle` uses `.sidebarAdaptable` only when `TabletomeLayout.usesSplitNavigation` is true; otherwise `.tabBarOnly`. See [`Support/TabBarAccessibilityBridge.swift`](../Support/TabBarAccessibilityBridge.swift).
- **Guided Match split:** Same predicate as tabs; outer navigation bar hidden only when split is active. See [`GuidedMatchDestinationView.swift`](../Features/GuidedMatch/GuidedMatchDestinationView.swift).
- **Fold / resize sync:** [`GuidedMatchLayoutSync.swift`](../Features/GuidedMatch/GuidedMatchLayoutSync.swift) maps hub tab ↔ split destination when `usesSplitNavigation` changes.

## Spearhead battle arrangements

Resolver: [`Features/Play/BattleScreen/BattleScreenArrangement.swift`](../Features/Play/BattleScreen/BattleScreenArrangement.swift).

| Arrangement | When |
|-------------|------|
| `twoColumn` | `shortHeight` (scoreboard sidebar + content column) |
| `wide` | `regular` context, container ≥ 720×560, not accessibility layout |
| `stacked` | otherwise |

Layout container: [`BattleScreenLayout.swift`](../Features/Play/BattleScreen/BattleScreenLayout.swift). UI test id: `battleScreen.layout.twoColumn`.

## Multitasking

- `INFOPLIST_KEY_UIRequiresFullScreen: NO` in [`project.yml`](../project.yml).
- Window fill: `ttWindowBackground()` on app root ([`TTWindowBackground.swift`](../DesignSystem/Theme/TTWindowBackground.swift)).

## Verification

| Field | Value |
|-------|-------|
| Unit tests | `TabletomeLayoutTests`, `BattleScreenArrangementTests`, `GuidedMatchLayoutSyncTests` |
| UI tests | `GuidedMatchLandscapeUITests` |
| Manual | iPhone 17 + Pro Max landscape battle; iPad 11 split/narrow window; iPhone Duo folded/open (see `ongoing/adaptive-layout-1.0.md`) |
| Last verified | 2026-10-31 |
