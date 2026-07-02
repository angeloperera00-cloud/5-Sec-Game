import SwiftUI

struct XPProgressView: View {
    let level: Int; let xp: Int; let progress: Double; let xpForNext: Int
    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            HStack {
                Label("Level \(level)", systemImage: "star.fill").font(DS.Font.headline).foregroundColor(.mutedGold)
                Spacer()
                Text("\(xp) / \(xpForNext) XP").font(DS.Font.caption).foregroundColor(.slateGray)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: DS.Radius.pill).fill(Color.softStone).frame(height: 8)
                    RoundedRectangle(cornerRadius: DS.Radius.pill)
                        .fill(LinearGradient(colors: [.mutedGold, .mutedGold.opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * max(0, min(1, progress)), height: 8)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: progress)
                }
            }.frame(height: 8)
        }
    }
}
