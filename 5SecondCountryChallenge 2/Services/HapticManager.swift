import UIKit

final class HapticManager {
    static let shared = HapticManager()
    private init() {}
    func success() { UINotificationFeedbackGenerator().notificationOccurred(.success) }
    func error()   { UINotificationFeedbackGenerator().notificationOccurred(.error) }
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    func selectionChanged() { UISelectionFeedbackGenerator().selectionChanged() }
}
