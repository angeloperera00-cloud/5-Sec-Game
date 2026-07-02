import SwiftUI

struct LeaderboardView: View {
    @State private var entries: [LeaderboardEntry] = []

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: DS.Spacing.lg) {

                // Header
                VStack(alignment: .leading, spacing: DS.Spacing.xxs) {
                    Text("Leaderboard")
                        .font(DS.Font.title).foregroundColor(.deepNavy)
                    Text("Your personal best scores")
                        .font(DS.Font.callout).foregroundColor(.slateGray)
                }
                .padding(.top, DS.Spacing.lg)

                if entries.isEmpty {
                    emptyState
                } else {
                    // Podium (top 3)
                    if entries.count >= 3 {
                        podium
                    }

                    // Full list
                    VStack(spacing: DS.Spacing.sm) {
                        ForEach(Array(entries.enumerated()), id: \.element.id) { i, entry in
                            leaderboardRow(rank: i + 1, entry: entry)
                        }
                    }
                }

                // Clears the fixed tab bar
                Spacer(minLength: 110)
            }
            .padding(.horizontal, DS.Spacing.md)
        }
        .background(Color.warmIvory.ignoresSafeArea())
        .onAppear { entries = StorageManager.shared.leaderboard }
    }

    // MARK: - Empty state
    private var emptyState: some View {
        VStack(spacing: DS.Spacing.md) {
            Image(systemName: "list.number")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.slateGray.opacity(0.4))
            Text("No scores yet")
                .font(DS.Font.title3).foregroundColor(.deepNavy)
            Text("Play a game to appear on the leaderboard")
                .font(DS.Font.callout).foregroundColor(.slateGray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(DS.Spacing.xxl)
        .cardStyle()
    }

    // MARK: - Podium
    private var podium: some View {
        HStack(alignment: .bottom, spacing: DS.Spacing.sm) {
            podiumCell(rank: 2, entry: entries[1], height: 80)
            podiumCell(rank: 1, entry: entries[0], height: 110)
            podiumCell(rank: 3, entry: entries[2], height: 60)
        }
    }

    private func podiumCell(rank: Int, entry: LeaderboardEntry, height: CGFloat) -> some View {
        let medal: String
        switch rank {
        case 1:  medal = "🥇"
        case 2:  medal = "🥈"
        default: medal = "🥉"
        }

        return VStack(spacing: DS.Spacing.xs) {
            Text(medal).font(.system(size: 24))
            Text("\(entry.score)")
                .font(DS.Font.display(18)).foregroundColor(.cardWhite)
            Text(entry.mode.rawValue)
                .font(.system(size: 10))
                .foregroundColor(.cardWhite.opacity(0.7))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .padding(.vertical, DS.Spacing.sm)
        .background(rank == 1 ? Color.deepOcean : Color.deepOcean.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.md, style: .continuous))
    }

    // MARK: - Leaderboard row
    private func leaderboardRow(rank: Int, entry: LeaderboardEntry) -> some View {
        let rankColor: Color
        switch rank {
        case 1:  rankColor = .mutedGold
        case 2:  rankColor = .slateGray
        case 3:  rankColor = Color(hex: "#C9794C")
        default: rankColor = .slateGray
        }

        return HStack(spacing: DS.Spacing.md) {
            Text("\(rank)")
                .font(DS.Font.display(16))
                .foregroundColor(rankColor)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: DS.Spacing.xxs) {
                Text("\(entry.score) pts")
                    .font(DS.Font.headline).foregroundColor(.deepNavy)
                HStack(spacing: DS.Spacing.xs) {
                    Text(entry.mode.rawValue)
                        .font(DS.Font.caption).foregroundColor(.slateGray)
                    Text("·").foregroundColor(.slateGray)
                    Text(entry.difficulty.rawValue)
                        .font(DS.Font.caption).foregroundColor(.slateGray)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: DS.Spacing.xxs) {
                Text(entry.accuracyPercent)
                    .font(DS.Font.callout).foregroundColor(.deepOcean)
                Text(entry.formattedDate)
                    .font(DS.Font.caption).foregroundColor(.slateGray)
            }
        }
        .padding(DS.Spacing.md)
        .cardStyle()
    }
}
