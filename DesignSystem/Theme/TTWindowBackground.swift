import SwiftUI
import UIKit

extension View {
    /// Paints connected windows with canvas color so Duo and resize gaps are not white.
    func ttWindowBackground() -> some View {
        background(TTWindowBackgroundRepresentable())
    }
}

private struct TTWindowBackgroundRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> TTWindowBackgroundView {
        TTWindowBackgroundView()
    }

    func updateUIView(_ uiView: TTWindowBackgroundView, context: Context) {
        uiView.applyCanvasBackground()
    }
}

private final class TTWindowBackgroundView: UIView {
    override func didMoveToWindow() {
        super.didMoveToWindow()
        applyCanvasBackground()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyCanvasBackground()
    }

    func applyCanvasBackground() {
        backgroundColor = .clear
        let color = UIColor(TTColor.canvas)
        window?.backgroundColor = color
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for sceneWindow in windowScene.windows {
                sceneWindow.backgroundColor = color
                sceneWindow.rootViewController?.view.backgroundColor = color
            }
        }
    }
}
