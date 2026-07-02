import SwiftUI

struct HomeView: View {
    @EnvironmentObject var progressVM: ProgressViewModel
    @EnvironmentObject var settingsVM: SettingsViewModel

    @State private var path         = NavigationPath()
    @State private var selectedTab: Tab = .home

    enum Tab { case home, progress, badges, leaderboard, settings }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottom) {
                tabContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                bottomTabBar
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationDestination(for: AppRoute.self) { route in
                routeDestination(route)
            }
        }
        .onAppear { progressVM.refresh() }
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .home:        homeContent
        case .progress:    ProgressView_Screen()
        case .badges:      BadgesView()
        case .leaderboard: LeaderboardView()
        case .settings:    SettingsView()
        }
    }

    // MARK: - Home content
    private var homeContent: some View {
        ZStack(alignment: .top) {
            GeometryReader { geo in
                if UIImage(named: "bg_home") != nil {
                    Image("bg_home", bundle: .main)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .ignoresSafeArea()
                } else {
                    LinearGradient(
                        colors: [
                            Color(red: 0.53, green: 0.81, blue: 0.95),
                            Color(red: 0.85, green: 0.95, blue: 1.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                }
            }
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    headerCard
                    statsRow
                    dailyChallengeCard
                    startButton
                    quickStatsCard
                    Spacer(minLength: 110)
                }
                .padding(.horizontal, 19)
                .padding(.top, 9)
            }
        }
    }

    // MARK: - Header Card
    private var headerCard: some View {
        HStack(alignment: .center, spacing: -30) {

            // Character — slightly smaller so the white card becomes tighter
            if UIImage(named: "character_explorer") != nil {
                Image("character_explorer", bundle: .main)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 125, height: 555)
                    .offset(x: -15, y: 2)
            }

            // Text block
            VStack(alignment: .leading, spacing: 3) {

                Text("Welcome back!")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(red: 0.55, green: 0.58, blue: 0.65))

                Text("5 Second\nCountry Challenge")
                    .font(.system(size: 23, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.08, green: 0.1, blue: 0.22))
                    .lineSpacing(-4)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(alignment: .center, spacing: 6)  {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color(red: 0.15, green: 0.45, blue: 0.95))
                            .frame(width: 30, height: 30)

                        Text("\(progressVM.level)")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                    }

                    Text("Level \(progressVM.level)")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(red: 0.15, green: 0.45, blue: 0.95))

                    Spacer(minLength: 6)

                    HStack(spacing: 2) {
                        Text("\(progressVM.totalXP)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color(red: 0.08, green: 0.1, blue: 0.22))

                        Text("/ \(progressVM.xpForNextLevel) XP")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(red: 0.55, green: 0.58, blue: 0.65))
                    }
                }
                .padding(.top, 8)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.88, green: 0.90, blue: 0.96))
                            .frame(height: 10)

                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.35, green: 0.65, blue: 1.0),
                                        Color(red: 0.15, green: 0.42, blue: 0.95)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: geo.size.width * max(0.04, min(1, progressVM.xpProgress)),
                                height: 10
                            )
                            .animation(.spring(response: 0.6), value: progressVM.xpProgress)
                    }
                }
                .frame(height: 10)
                .padding(.top, 5)
            }
            .padding(.leading, 0)
            .padding(.top, 12)
            .padding(.bottom, 12)
            .padding(.trailing, 14)
        }
        .padding(.leading, 8)
        .frame(maxWidth: .infinity)
        .frame(height: 158)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: 6)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    // MARK: - Stats Row
    private var statsRow: some View {
        HStack(spacing: 10) {
            statCard(
                value: "\(progressVM.bestScore)",
                label: "Best Score",
                imageName: "icon_trophy",
                fallbackIcon: "trophy.fill",
                fallbackColor: Color(red: 1.0, green: 0.75, blue: 0.0),
                sparkle: true
            )
            statCard(
                value: "\(progressVM.bestStreak)",
                label: "Best Streak",
                imageName: "icon_flame",
                fallbackIcon: "flame.fill",
                fallbackColor: Color(red: 1.0, green: 0.4, blue: 0.1),
                sparkle: false
            )
            statCard(
                value: "\(progressVM.accuracyPercent)%",
                label: "Accuracy",
                imageName: "icon_target",
                fallbackIcon: "target",
                fallbackColor: Color(red: 0.1, green: 0.72, blue: 0.45),
                sparkle: true
            )
        }
    }

    private func statCard(
        value: String,
        label: String,
        imageName: String,
        fallbackIcon: String,
        fallbackColor: Color,
        sparkle: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                Group {
                    if UIImage(named: imageName) != nil {
                        Image(imageName, bundle: .main)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 52, height: 52)
                    } else {
                        Image(systemName: fallbackIcon)
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(fallbackColor)
                            .frame(width: 52, height: 42)
                    }
                }
                if sparkle {
                    Image(systemName: "sparkle")
                        .font(.system(size: 10))
                        .foregroundColor(.mutedGold)
                        .offset(x: 6, y: -4)
                }
            }

            Text(value)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.deepNavy)

            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.slateGray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.07), radius: 12, x: 0, y: 4)
        )
    }

    // MARK: - Daily Challenge Card
    private var dailyChallengeCard: some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.08, green: 0.70, blue: 0.48),
                            Color(red: 0.05, green: 0.55, blue: 0.38)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(
                    color: Color(red: 0.05, green: 0.55, blue: 0.38).opacity(0.4),
                    radius: 14, x: 0, y: 6
                )

            HStack(spacing: 0) {
                // Left text
                VStack(alignment: .leading, spacing: 10) {
                    Text("Daily Challenge")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("New countries every day!")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.88))


                    HStack(spacing: 10) {
                        Image(systemName: "calendar.badge.checkmark")
                            .font(.system(size: 17, weight: .semibold))
                        Text("Coming Soon")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(Color(red: 0.05, green: 0.55, blue: 0.38))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.white)
                    )
                }
                .padding(.leading, 18)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity, alignment: .leading)

                // Right illustration
                if UIImage(named: "daily_challenge_banner") != nil {
                    Image("daily_challenge_banner", bundle: .main)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 170, height: 180)
                        .clipped()
                } else if UIImage(named: "character_globe_hat") != nil {
                    Image("character_globe_hat", bundle: .main)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 120)
                        .padding(.trailing, 8)
                } else {
                    Image(systemName: "globe.europe.africa.fill")
                        .font(.system(size: 70))
                        .foregroundColor(.white.opacity(0.35))
                        .frame(width: 140, height: 140)
                }
            }
        }
        .frame(height: 145)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    // MARK: - Start Button
    private var startButton: some View {
        Button {
            HapticManager.shared.impact(.medium)
            path.append(AppRoute.gameModeSelection)
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "play.fill")
                    .font(.system(size: 20, weight: .bold))
                Text("Start Game")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.18, green: 0.48, blue: 0.98),
                                Color(red: 0.1, green: 0.32, blue: 0.88)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(
                        color: Color(red: 0.1, green: 0.32, blue: 0.88).opacity(0.5),
                        radius: 18, x: 0, y: 8
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Quick Stats Card
    private var quickStatsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(red: 0.18, green: 0.48, blue: 0.98))

                Text("Your Stats")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.deepNavy)

                Spacer()
            }

            HStack(spacing: 0) {
                quickStatItem(
                    value: "\(progressVM.totalGamesPlayed)",
                    label: "Games",
                    imageName: "icon_gamepad",
                    fallbackIcon: "gamecontroller.fill",
                    iconColor: Color(red: 0.45, green: 0.42, blue: 0.88)
                )

                Rectangle()
                    .fill(Color(red: 0.9, green: 0.9, blue: 0.93))
                    .frame(width: 1, height: 48)

                quickStatItem(
                    value: "\(progressVM.totalCorrect)",
                    label: "Correct",
                    imageName: "icon_checkmark",
                    fallbackIcon: "checkmark.circle.fill",
                    iconColor: Color(red: 0.18, green: 0.72, blue: 0.35)
                )

                Rectangle()
                    .fill(Color(red: 0.9, green: 0.9, blue: 0.93))
                    .frame(width: 1, height: 48)

                quickStatItem(
                    value: "Lv \(progressVM.level)",
                    label: "Level",
                    imageName: "icon_xp",
                    fallbackIcon: "star.fill",
                    iconColor: Color(red: 0.58, green: 0.32, blue: 0.88)
                )
            }
        }
        .padding(.top, 18)
        .padding(.horizontal, 18)
        .padding(.bottom, 10)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.07), radius: 14, x: 0, y: 5)
        )
    }

    private func quickStatItem(
        value: String,
        label: String,
        imageName: String,
        fallbackIcon: String,
        iconColor: Color
    ) -> some View {
        VStack(spacing: 4) {
            if UIImage(named: imageName) != nil {
                Image(imageName, bundle: .main)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 46, height: 46)
            } else {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 50, height: 50)

                    Image(systemName: fallbackIcon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(iconColor)
                }
            }

            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.deepNavy)
                .padding(.top, 6)

            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.slateGray)
                .padding(.top, -2)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Bottom Tab Bar
    private var bottomTabBar: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.black.opacity(0.07))
                .frame(height: 1)
            HStack(spacing: 0) {
                ForEach(tabItems, id: \.label) { item in
                    tabButton(item)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 10)
            .padding(.bottom, 8)
            Rectangle()
                .fill(Color.clear)
                .frame(height: safeAreaBottom)
        }
        .background(Color.white)
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: -3)
    }

    private var safeAreaBottom: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.bottom ?? 0
    }

    private struct TabItem {
        let tab: Tab; let icon: String; let label: String
    }

    private let tabItems: [TabItem] = [
        TabItem(tab: .home,        icon: "house.fill",     label: "Home"),
        TabItem(tab: .progress,    icon: "chart.bar.fill", label: "Progress"),
        TabItem(tab: .badges,      icon: "rosette",        label: "Badges"),
        TabItem(tab: .leaderboard, icon: "list.number",    label: "Scores"),
        TabItem(tab: .settings,    icon: "gearshape.fill", label: "Settings"),
    ]

    private func tabButton(_ item: TabItem) -> some View {
        let isSelected = selectedTab == item.tab
        let blue = Color(red: 0.15, green: 0.45, blue: 0.95)
        return Button {
            HapticManager.shared.selectionChanged()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                selectedTab = item.tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: item.icon)
                    .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? blue : Color.slateGray.opacity(0.55))
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3), value: isSelected)
                Text(item.label)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? blue : Color.slateGray.opacity(0.55))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Navigation destinations
    @ViewBuilder
    private func routeDestination(_ route: AppRoute) -> some View {
        switch route {
        case .gameModeSelection:
            GameModeSelectionView(path: $path)
        case .difficultySelection(let m):
            DifficultySelectionView(mode: m, path: $path)
        case .quiz(let m, let d):
            QuizView(mode: m, difficulty: d, path: $path)
        case .result(let r):
            ResultView(result: r, path: $path)
        default:
            EmptyView()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(ProgressViewModel())
        .environmentObject(SettingsViewModel())
}
