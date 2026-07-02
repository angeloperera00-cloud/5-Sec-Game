import SwiftUI

struct ModeCardView: View {
    let mode: GameMode; let onTap: () -> Void
    @State private var isPressed = false
    var body: some View {
        Button(action: { HapticManager.shared.impact(.medium); onTap() }) {
            HStack(spacing: DS.Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: DS.Radius.sm, style: .continuous)
                        .fill(Color.deepOcean).frame(width: 52, height: 52)
                    Image(systemName: mode.icon)
                        .font(.system(size: 22, weight: .semibold)).foregroundColor(.mutedGold)
                }
                VStack(alignment: .leading, spacing: DS.Spacing.xxs) {
                    Text(mode.rawValue).font(DS.Font.title3).foregroundColor(.deepNavy)
                    Text(mode.description).font(DS.Font.callout).foregroundColor(.slateGray).lineLimit(2)
                    Text(mode.difficultyLabel).font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.mutedGold).padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color.mutedGold.opacity(0.12)).clipShape(Capsule())
                }
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 13, weight: .semibold)).foregroundColor(.slateGray)
            }
            .padding(DS.Spacing.md).cardStyle().scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onChanged { _ in withAnimation(.spring(response: 0.2)) { isPressed = true } }
            .onEnded   { _ in withAnimation(.spring(response: 0.3)) { isPressed = false } })
    }
}
