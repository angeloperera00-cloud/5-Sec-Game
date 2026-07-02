import SwiftUI

struct DifficultyCardView: View {
    let difficulty: Difficulty; let isSelected: Bool; let onTap: () -> Void
    @State private var isPressed = false
    private var accentColor: Color {
        switch difficulty {
        case .easy: return .elegantGreen; case .medium: return .mutedGold
        case .hard: return .mutedRed;     case .worldMaster: return .deepOcean
        }
    }
    var body: some View {
        Button(action: { HapticManager.shared.impact(.medium); onTap() }) {
            VStack(alignment: .leading, spacing: DS.Spacing.sm) {
                HStack {
                    Image(systemName: difficulty.icon).font(.system(size: 20, weight: .semibold)).foregroundColor(accentColor)
                    Spacer()
                    Text(difficulty.multiplierLabel).font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(accentColor).padding(.horizontal, 8).padding(.vertical, 4)
                        .background(accentColor.opacity(0.12)).clipShape(Capsule())
                }
                Text(difficulty.rawValue).font(DS.Font.title3).foregroundColor(.deepNavy)
                Text(difficulty.description).font(DS.Font.caption).foregroundColor(.slateGray).lineLimit(2)
                Divider().opacity(0.4)
                Text(difficulty.recommendedFor).font(.system(size: 11, weight: .medium)).foregroundColor(.slateGray).lineLimit(1)
            }
            .padding(DS.Spacing.md)
            .background(isSelected ? accentColor.opacity(0.08) : Color.cardWhite)
            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.lg, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: DS.Radius.lg, style: .continuous)
                .stroke(isSelected ? accentColor : Color.clear, lineWidth: 2))
            .appShadow(isSelected ? DS.Shadow.lift : DS.Shadow.soft)
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onChanged { _ in withAnimation(.spring(response: 0.2)) { isPressed = true } }
            .onEnded   { _ in withAnimation(.spring(response: 0.3)) { isPressed = false } })
    }
}
