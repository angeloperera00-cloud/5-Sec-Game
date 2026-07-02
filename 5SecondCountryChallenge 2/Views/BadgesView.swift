import SwiftUI

struct BadgesView: View {
    @EnvironmentObject var progressVM: ProgressViewModel

    private var unlocked: [Badge] { progressVM.badges.filter(\.isUnlocked) }
    private var locked:   [Badge] { progressVM.badges.filter { !$0.isUnlocked } }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: DS.Spacing.lg) {

                // Header
                VStack(alignment: .leading, spacing: DS.Spacing.xxs) {
                    Text("Badges")
                        .font(DS.Font.title).foregroundColor(.deepNavy)
                    Text("\(unlocked.count) of \(progressVM.badges.count) earned")
                        .font(DS.Font.callout).foregroundColor(.slateGray)
                }
                .padding(.top, DS.Spacing.lg)

                // Overall progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: DS.Radius.pill)
                            .fill(Color.softStone)
                            .frame(height: 8)
                        RoundedRectangle(cornerRadius: DS.Radius.pill)
                            .fill(Color.mutedGold)
                            .frame(
                                width: geo.size.width * (progressVM.badges.isEmpty ? 0 :
                                    Double(unlocked.count) / Double(progressVM.badges.count)),
                                height: 8
                            )
                            .animation(.spring(response: 0.5), value: unlocked.count)
                    }
                }
                .frame(height: 8)

                // Earned badges
                if !unlocked.isEmpty {
                    Text("Earned")
                        .font(DS.Font.title3).foregroundColor(.deepNavy)

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: DS.Spacing.sm
                    ) {
                        ForEach(unlocked) { badge in
                            BadgeCardView(badge: badge)
                        }
                    }
                }

                // Locked badges
                if !locked.isEmpty {
                    Text("Locked")
                        .font(DS.Font.title3).foregroundColor(.deepNavy)

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: DS.Spacing.sm
                    ) {
                        ForEach(locked) { badge in
                            lockedBadgeCard(badge)
                        }
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

    // MARK: - Locked badge card
    private func lockedBadgeCard(_ badge: Badge) -> some View {
        VStack(spacing: DS.Spacing.xs) {
            ZStack {
                Circle()
                    .fill(Color.softStone)
                    .frame(width: 52, height: 52)
                Image(systemName: badge.icon)
                    .font(.system(size: 22, weight: .light))
                    .foregroundColor(.slateGray.opacity(0.4))
                Image(systemName: "lock.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.slateGray.opacity(0.5))
                    .offset(x: 16, y: 16)
            }

            Text(badge.name)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.slateGray)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            Text(badge.description)
                .font(.system(size: 9))
                .foregroundColor(.slateGray.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
        .frame(maxWidth: .infinity)
        .padding(DS.Spacing.sm)
        .background(Color.softStone.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.md, style: .continuous))
        .opacity(0.6)
    }
}
