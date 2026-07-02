import SwiftUI

struct DifficultySelectionView: View {
    let mode: GameMode; @Binding var path: NavigationPath
    @State private var selected: Difficulty? = nil
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: DS.Spacing.lg) {
                HStack(spacing: DS.Spacing.md) {
                    ZStack {
                        RoundedRectangle(cornerRadius: DS.Radius.sm, style: .continuous)
                            .fill(Color.mutedGold.opacity(0.15)).frame(width: 52, height: 52)
                        Image(systemName: mode.icon).font(.system(size: 24, weight: .semibold)).foregroundColor(.mutedGold)
                    }
                    VStack(alignment: .leading, spacing: DS.Spacing.xxs) {
                        Text(mode.rawValue).font(DS.Font.headline).foregroundColor(.deepNavy)
                        Text(mode.description).font(DS.Font.callout).foregroundColor(.slateGray).lineLimit(2)
                    }; Spacer()
                }.padding(DS.Spacing.md).cardStyle()

                VStack(alignment: .leading, spacing: DS.Spacing.xs) {
                    Text("Select Difficulty").font(DS.Font.title).foregroundColor(.deepNavy)
                    Text("Higher difficulty = bigger score multiplier").font(DS.Font.callout).foregroundColor(.slateGray)
                }.frame(maxWidth: .infinity, alignment: .leading)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: DS.Spacing.sm) {
                    ForEach(Difficulty.allCases, id: \.self) { diff in
                        DifficultyCardView(difficulty: diff, isSelected: selected == diff) {
                            withAnimation(.spring(response: 0.3)) { selected = diff }
                        }
                    }
                }

                if let diff = selected {
                    PrimaryButton("Start \(mode.rawValue)", icon: "play.fill") {
                        path.append(AppRoute.quiz(mode: mode, difficulty: diff))
                    }.transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    PrimaryButton("Select a Difficulty", icon: nil) {}.opacity(0.4).disabled(true)
                }
                Spacer(minLength: DS.Spacing.xxl)
            }
            .padding(.horizontal, DS.Spacing.md).padding(.top, DS.Spacing.md)
        }
        .background(Color.warmIvory.ignoresSafeArea())
        .navigationTitle(mode.rawValue).navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.warmIvory, for: .navigationBar)
        .animation(.spring(response: 0.4), value: selected)
    }
}
