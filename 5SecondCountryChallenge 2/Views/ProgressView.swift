import SwiftUI

struct ProgressView_Screen: View {
    @EnvironmentObject var progressVM: ProgressViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: DS.Spacing.lg) {

                VStack(alignment: .leading, spacing: DS.Spacing.xxs) {
                    Text("Your Progress")
                        .font(DS.Font.title).foregroundColor(.deepNavy)
                    Text("Track your geography journey")
                        .font(DS.Font.callout).foregroundColor(.slateGray)
                }
                .padding(.top, DS.Spacing.lg)

                // Level card
                VStack(alignment: .leading, spacing: DS.Spacing.md) {
                    HStack {
                        VStack(alignment: .leading, spacing: DS.Spacing.xxs) {
                            Text("Level \(progressVM.level)")
                                .font(DS.Font.title).foregroundColor(.cardWhite)
                            Text("Geography Explorer")
                                .font(DS.Font.callout).foregroundColor(.cardWhite.opacity(0.7))
                        }
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(Color.mutedGold.opacity(0.2))
                                .frame(width: 56, height: 56)
                            Text("\(progressVM.level)")
                                .font(DS.Font.display(24)).foregroundColor(.mutedGold)
                        }
                    }
                    XPProgressView(
                        level: progressVM.level,
                        xp: progressVM.totalXP,
                        progress: progressVM.xpProgress,
                        xpForNext: progressVM.xpForNextLevel
                    )
                }
                .padding(DS.Spacing.lg)
                .darkCardStyle()

                // Stats grid
                Text("Statistics")
                    .font(DS.Font.title3).foregroundColor(.deepNavy)

                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: DS.Spacing.sm
                ) {
                    StatCardView(title: "Games Played", value: "\(progressVM.totalGamesPlayed)",
                                 icon: "gamecontroller.fill",  accentColor: .deepOcean)
                    StatCardView(title: "Correct",      value: "\(progressVM.totalCorrect)",
                                 icon: "checkmark.circle.fill", accentColor: .elegantGreen)
                    StatCardView(title: "Wrong",        value: "\(progressVM.totalWrong)",
                                 icon: "xmark.circle.fill",    accentColor: .mutedRed)
                    StatCardView(title: "Best Streak",  value: "\(progressVM.bestStreak)",
                                 icon: "flame.fill",           accentColor: .mutedRed)
                    StatCardView(title: "Best Score",   value: "\(progressVM.bestScore)",
                                 icon: "trophy.fill",          accentColor: .mutedGold)
                    StatCardView(title: "Accuracy",     value: "\(progressVM.accuracyPercent)%",
                                 icon: "target",               accentColor: .deepOcean)
                }

                // Continent breakdown
                Text("Countries by Continent")
                    .font(DS.Font.title3).foregroundColor(.deepNavy)

                VStack(spacing: DS.Spacing.xs) {
                    ForEach(Country.Continent.allCases, id: \.self) { continent in
                        continentRow(continent)
                    }
                }

                // Clears the fixed tab bar
                Spacer(minLength: 110)
            }
            .padding(.horizontal, DS.Spacing.md)
        }
        .background(Color.warmIvory.ignoresSafeArea())
        .onAppear { progressVM.refresh() }
    }

    // MARK: - Continent row
    private func continentRow(_ continent: Country.Continent) -> some View {
        let total = CountryDatabase.all.filter { $0.continent == continent }.count
        let icons: [Country.Continent: String] = [
            .europe:       "flag.fill",
            .northAmerica: "building.columns.fill",
            .southAmerica: "leaf.fill",
            .asia:         "sun.and.horizon.fill",
            .africa:       "globe.africa.fill",
            .oceania:      "water.waves",
            .middleEast:   "moon.fill"
        ]
        return HStack(spacing: DS.Spacing.md) {
            Image(systemName: icons[continent] ?? "globe")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.mutedGold)
                .frame(width: 24)
            Text(continent.rawValue)
                .font(DS.Font.callout).foregroundColor(.deepNavy)
            Spacer()
            Text("\(total) countries")
                .font(DS.Font.caption).foregroundColor(.slateGray)
                .padding(.horizontal, 8).padding(.vertical, 3)
                .background(Color.softStone)
                .clipShape(Capsule())
        }
        .padding(.vertical, DS.Spacing.xs)
        .padding(.horizontal, DS.Spacing.md)
        .background(Color.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.md, style: .continuous))
        .appShadow(DS.Shadow.soft)
    }
}
