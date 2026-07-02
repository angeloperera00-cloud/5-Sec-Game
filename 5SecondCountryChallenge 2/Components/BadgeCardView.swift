import SwiftUI

struct BadgeCardView: View {
    let badge: Badge
    var body: some View {
        VStack(spacing: DS.Spacing.xs) {
            ZStack {
                Circle().fill(badge.isUnlocked ? Color.mutedGold.opacity(0.15) : Color.softStone)
                    .frame(width: 60, height: 60)
                Image(systemName: badge.icon).font(.system(size: 26, weight: .medium))
                    .foregroundColor(badge.isUnlocked ? .mutedGold : .slateGray.opacity(0.4))
            }
            .overlay(Circle().stroke(badge.isUnlocked ? Color.mutedGold.opacity(0.5) : Color.clear, lineWidth: 2))
            Text(badge.name).font(.system(size: 12, weight: .semibold))
                .foregroundColor(badge.isUnlocked ? .deepNavy : .slateGray)
                .multilineTextAlignment(.center).lineLimit(2)
            if !badge.isUnlocked {
                Image(systemName: "lock.fill").font(.system(size: 10)).foregroundColor(.slateGray.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity).padding(DS.Spacing.sm)
        .background(badge.isUnlocked ? Color.cardWhite : Color.softStone.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.md, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: DS.Radius.md, style: .continuous)
            .stroke(badge.isUnlocked ? Color.mutedGold.opacity(0.2) : Color.clear, lineWidth: 1))
        .appShadow(badge.isUnlocked ? DS.Shadow.soft : DS.ShadowStyle(color: .clear, radius: 0, x: 0, y: 0))
        .opacity(badge.isUnlocked ? 1.0 : 0.6)
    }
}
