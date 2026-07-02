import SwiftUI

struct ResultView: View {
    let result: GameResult; @Binding var path: NavigationPath
    @EnvironmentObject var progressVM: ProgressViewModel
    @State private var appeared = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: DS.Spacing.lg) {
                Spacer(minLength: DS.Spacing.lg)
                Text(result.motivationalEmoji).font(.system(size: 70))
                    .scaleEffect(appeared ? 1 : 0.3).opacity(appeared ? 1 : 0)

                VStack(spacing: DS.Spacing.xs) {
                    Text(result.motivationalMessage).font(DS.Font.title).foregroundColor(.deepNavy).multilineTextAlignment(.center)
                    Text("\(result.mode.rawValue) · \(result.difficulty.rawValue)").font(DS.Font.callout).foregroundColor(.slateGray)
                }.opacity(appeared ? 1 : 0)

                VStack(spacing: DS.Spacing.xs) {
                    Text("\(result.score)").font(DS.Font.display(56)).foregroundColor(.cardWhite).monospacedDigit()
                    Text("Total Score").font(DS.Font.callout).foregroundColor(.cardWhite.opacity(0.7))
                }.padding(DS.Spacing.xl).frame(maxWidth: .infinity).darkCardStyle().opacity(appeared ? 1 : 0)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: DS.Spacing.sm) {
                    ResultStat(title: "Correct",     value: "\(result.correct)",          icon: "checkmark.circle.fill", color: .elegantGreen)
                    ResultStat(title: "Wrong",       value: "\(result.wrong)",            icon: "xmark.circle.fill",     color: .mutedRed)
                    ResultStat(title: "Accuracy",    value: "\(result.accuracyPercent)%", icon: "target",                color: .deepOcean)
                    ResultStat(title: "Best Streak", value: "\(result.bestStreak)",       icon: "flame.fill",            color: .mutedGold)
                }.opacity(appeared ? 1 : 0)

                HStack(spacing: DS.Spacing.sm) {
                    Image(systemName: "sparkles").font(.system(size: 18)).foregroundColor(.mutedGold)
                    Text("+\(result.xpEarned) XP Earned").font(DS.Font.headline).foregroundColor(.deepNavy)
                    Spacer()
                    Text("Level \(progressVM.level)").font(DS.Font.callout).foregroundColor(.mutedGold)
                        .padding(.horizontal, 10).padding(.vertical, 4)
                        .background(Color.mutedGold.opacity(0.12)).clipShape(Capsule())
                }.padding(DS.Spacing.md).cardStyle().opacity(appeared ? 1 : 0)

                VStack(spacing: DS.Spacing.sm) {
                    PrimaryButton("Play Again", icon: "arrow.clockwise") {
                        if path.count >= 2 { path.removeLast(2) } else { path.removeLast(path.count) }
                    }
                    SecondaryButton("Change Mode", icon: "square.grid.2x2") {
                        if path.count >= 3 { path.removeLast(3) } else { path.removeLast(path.count) }
                    }
                    SecondaryButton("Back to Home") { path.removeLast(path.count) }
                }
                Spacer(minLength: DS.Spacing.xxl)
            }.padding(.horizontal, DS.Spacing.md)
        }
        .background(Color.warmIvory.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Round Complete").navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.warmIvory, for: .navigationBar)
        .onAppear {
            progressVM.refresh()
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) { appeared = true }
        }
    }
}

private struct ResultStat: View {
    let title: String; let value: String; let icon: String; let color: Color
    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            Image(systemName: icon).font(.system(size: 16, weight: .semibold)).foregroundColor(color)
            Text(value).font(DS.Font.title2).foregroundColor(.deepNavy)
            Text(title).font(DS.Font.caption).foregroundColor(.slateGray)
        }.frame(maxWidth: .infinity, alignment: .leading).padding(DS.Spacing.md).cardStyle()
    }
}
