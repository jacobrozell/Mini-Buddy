# MiniMuster Port Freeze

**Effective:** 2026-06-17  
**Parent:** [UnifiedAppPlan.md](UnifiedAppPlan.md)

## Policy

The MiniMuster iOS app at `WarhammerTracker/ios/` is **frozen as a port source**.

- **No new features** in MiniMuster unless they unblock an urgent MiniMuster-only TestFlight (unlikely).
- **Bug fixes:** only critical crashes/data-loss; prefer fixing in Mini Buddy after port.
- **All new product work** lands in **Mini Buddy** per the unified plan.

## What to port (inventory)

| MiniMuster path | Mini Buddy destination | Phase |
|-----------------|----------------------|-------|
| `Models/` | `Data/Hobby/Models/` | 4 |
| `DataIO/` | `Data/Hobby/DataIO/` | 4 |
| `Domain/` (non-Muster play) | `Domain/` | 2 |
| `Domain/Muster/` | `Domain/Muster/` | 2 |
| `Features/Collection/`, `Paints/` | `Features/Bench/` | 5 |
| `Features/Muster/` | `Features/Muster/` | 6 |
| `DesignSystem/` | Merge into `DesignSystem/` | 3 |
| `MiniMusterWidget/` | Widget extension in Mini Buddy | 9 |
| `Resources/UnitCatalog/` | `Resources/Catalogs/` | 6 |

## Web companion

`WarhammerTracker` web app remains the CSV/backup interchange format. Preserve round-trip compatibility when porting DataIO (Phase 4).

## Resume criteria

Unfreeze only if Mini Buddy merge is abandoned. If so, update this file and `UnifiedAppPlan.md`.
