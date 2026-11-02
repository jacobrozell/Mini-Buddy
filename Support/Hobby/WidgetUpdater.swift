import Foundation
import SwiftData
import MiniBuddyDomain
import MiniBuddyHobbyData

/// Widget extension lands in Phase 9. No-op until then.
@MainActor
enum WidgetUpdater {
    static func refresh(context: ModelContext) {}

    static func refresh(armies: [Army], globalPipeline: [PipelineStage]?) {}
}
