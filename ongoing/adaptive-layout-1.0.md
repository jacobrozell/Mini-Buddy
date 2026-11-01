# Adaptive layout 1.0.0

**Branch:** `feature/uioverhaul` (merge to `release/1.0.0`)  
**Last updated:** 2026-10-31

## Done in code

- Size-class layout core (`compact` / `shortHeight` / `regular`) replaces idiom-based `TabletomeLayoutContext`.
- Sidebar-adaptable tabs + Guided Match split at regular/regular only.
- Spearhead battle `BattleScreenArrangement` (stacked / twoColumn / wide).
- Duo window background (`ttWindowBackground`), `UIRequiresFullScreen: NO`.
- `SpearheadBattlePresentation` owned on `GuidedMatchView` and injected into embedded battle (sheet bindings in `SpearheadBattleView` — follow-up).

## Manual smoke (agent / human)

- [ ] iPhone 17 landscape: full setup + battle round; tab bar hidden in battle
- [ ] iPhone 17 Pro Max landscape: Guided Match back button visible
- [ ] iPad Pro 11: sidebar tabs; Guided Match split; battle wide when detail is wide
- [ ] iPad narrow window (~⅓ width): phone stack, no split
- [ ] iPhone Duo folded: same as iPhone
- [ ] iPhone Duo open: split + readable width on Rules detail
- [ ] Fold/unfold on Battle tab: same hub stage (battle)

## References

- Spec: [`specs/AdaptiveLayoutSpec.md`](../specs/AdaptiveLayoutSpec.md)
- PuzzleBuddy pattern: Duo checklist in PuzzleBuddy `ongoing/iphone-duo-1.1.0.md`
