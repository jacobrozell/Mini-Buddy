import SwiftUI
import TabletomeHobbyData

/// Bench pillar — MiniMuster Collection + Paints merged into one tab.
struct BenchTab: View {
  @Environment(AppRouter.self) private var router
  @Environment(\.verticalSizeClass) private var verticalSizeClass
  @State private var section: BenchSection = .collection

  enum BenchSection: String, CaseIterable, Identifiable, Hashable {
    case collection
    case paints

    var id: String { rawValue }

    var label: String {
      switch self {
      case .collection: String(localized: "Collection")
      case .paints: String(localized: "Paints")
      }
    }

    var icon: String {
      switch self {
      case .collection: "shield.lefthalf.filled"
      case .paints: "paintpalette.fill"
      }
    }
  }

  private var visibleSections: [BenchSection] {
    if ReleaseSurface.showsPaintsInBench {
      return BenchSection.allCases
    }
    return [.collection]
  }

  var body: some View {
    Group {
      switch section {
      case .collection:
        CollectionTab(showsSectionPicker: showsSectionPicker) { sectionPicker }
      case .paints:
        PaintsTab(showsSectionPicker: showsSectionPicker) { sectionPicker }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onAppear { syncSectionFromRouter() }
    .onChange(of: router.tab) { _, _ in syncSectionFromRouter() }
    .onChange(of: section) { _, newValue in
      switch newValue {
      case .collection: router.tab = .armies
      case .paints: router.tab = .paints
      }
    }
    .accessibilityIdentifier("bench.root")
  }

  private var showsSectionPicker: Bool {
    visibleSections.count > 1
  }

  /// Sits under the navigation bar. A sibling above the stack is covered by that
  /// bar, so the Paints segment never receives the tap.
  private var sectionPicker: some View {
    TTSegmentedControl(
      selection: $section,
      options: visibleSections,
      title: { $0.label },
      systemImage: { $0.icon },
      accessibilityIdentifier: { "bench.section.\($0.rawValue)" }
    )
    .padding(.horizontal, DesignTokens.Spacing.md)
    .padding(.vertical, verticalSizeClass == .compact ? DesignTokens.Spacing.xs : DesignTokens.Spacing.sm)
    .background(TTColor.canvas)
  }

  private func syncSectionFromRouter() {
    switch router.tab {
    case .armies: section = .collection
    case .paints:
      section = ReleaseSurface.showsPaintsInBench ? .paints : .collection
    case .muster: break
    }
  }
}

extension View {
    /// Pins the Collection / Paints switch under the navigation bar.
    @ViewBuilder
    func benchSectionPicker<Picker: View>(
        enabled: Bool,
        @ViewBuilder picker: () -> Picker
    ) -> some View {
        if enabled {
            safeAreaInset(edge: .top, spacing: 0, content: picker)
        } else {
            self
        }
    }
}
