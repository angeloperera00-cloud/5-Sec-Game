import SwiftUI

struct PrimaryButton: View {
    let title: String; let icon: String?; let action: () -> Void
    var isFullWidth: Bool = true
    @State private var isPressed = false
    init(_ title: String, icon: String? = nil, isFullWidth: Bool = true, action: @escaping () -> Void) {
        self.title = title; self.icon = icon; self.isFullWidth = isFullWidth; self.action = action
    }
    var body: some View {
        Button(action: { HapticManager.shared.impact(.light); action() }) {
            HStack(spacing: DS.Spacing.xs) {
                if let icon { Image(systemName: icon).font(.system(size: 16, weight: .semibold)) }
                Text(title).font(DS.Font.headline)
            }
            .foregroundColor(.darkCard)
            .padding(.vertical, DS.Spacing.md).padding(.horizontal, DS.Spacing.xl)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .background(Color.mutedGold)
            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.md, style: .continuous))
            .appShadow(DS.Shadow.card)
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onChanged { _ in withAnimation(.spring(response: 0.2)) { isPressed = true } }
            .onEnded   { _ in withAnimation(.spring(response: 0.3)) { isPressed = false } })
    }
}
