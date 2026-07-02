import SwiftUI

struct GameModeSelectionView: View {
    @Binding var path: NavigationPath

    private let modes: [GameMode] = [.flag, .map, .mixed, .rush]

    var body: some View {
        ZStack {
            GeometryReader { geo in
                if UIImage(named: "bg_game_modes") != nil {
                    Image("bg_game_modes", bundle: .main)
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
                VStack(spacing: 0) {
                    ZStack(alignment: .trailing) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Choose a Mode")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 0.08, green: 0.1, blue: 0.22))
                            Text("Each mode offers a unique challenge")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Color(red: 0.35, green: 0.38, blue: 0.48))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 130)

                        if UIImage(named: "") != nil {
                            Image("", bundle: .main)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 1, height: 1)
                                .offset(y: 10)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 20)

                    VStack(spacing: 14) {
                        ForEach(modes, id: \.self) { mode in
                            modeCard(mode: mode)
                        }
                    }
                    .padding(.horizontal, 16)

                    Spacer(minLength: 60)
                }
            }
        }
        .navigationTitle("Game Modes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.clear, for: .navigationBar)
    }

    private func modeCard(mode: GameMode) -> some View {
        Button {
            HapticManager.shared.impact(.medium)
            path.append(AppRoute.difficultySelection(mode: mode))
        } label: {
            HStack(spacing: 10) {
                Group {
                    if UIImage(named: iconName(for: mode)) != nil {
                        Image(iconName(for: mode), bundle: .main)
                            .resizable()
                            .scaledToFit()
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(iconColor(for: mode))
                            Image(systemName: mode.icon)
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: iconColor(for: mode).opacity(0.3), radius: 8, x: 0, y: 4)

                VStack(alignment: .leading, spacing: 4) {
                    Text(mode.rawValue)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.08, green: 0.1, blue: 0.22))
                    Text(mode.description)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(red: 0.45, green: 0.48, blue: 0.55))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(mode.difficultyLabel)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(pillTextColor(for: mode))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(pillBgColor(for: mode)))
                        .padding(.top, 2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 0.7, green: 0.72, blue: 0.78))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.07), radius: 14, x: 0, y: 5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func iconName(for mode: GameMode) -> String {
        switch mode {
        case .flag:  return "icon_mode_flag"
        case .map:   return "icon_mode_map"
        case .mixed: return "icon_mode_mixed"
        case .rush:  return "icon_mode_rush"
        }
    }

    private func iconColor(for mode: GameMode) -> Color {
        switch mode {
        case .flag:  return Color(red: 0.15, green: 0.45, blue: 0.95)
        case .map:   return Color(red: 0.08, green: 0.65, blue: 0.75)
        case .mixed: return Color(red: 0.45, green: 0.25, blue: 0.85)
        case .rush:  return Color(red: 0.15, green: 0.70, blue: 0.35)
        }
    }

    private func pillBgColor(for mode: GameMode) -> Color {
        switch mode {
        case .flag:  return Color(red: 1.0, green: 0.88, blue: 0.65)
        case .map:   return Color(red: 1.0, green: 0.88, blue: 0.65)
        case .mixed: return Color(red: 0.88, green: 0.82, blue: 1.0)
        case .rush:  return Color(red: 1.0, green: 0.82, blue: 0.82)
        }
    }

    private func pillTextColor(for mode: GameMode) -> Color {
        switch mode {
        case .flag:  return Color(red: 0.8, green: 0.55, blue: 0.0)
        case .map:   return Color(red: 0.8, green: 0.55, blue: 0.0)
        case .mixed: return Color(red: 0.45, green: 0.20, blue: 0.85)
        case .rush:  return Color(red: 0.85, green: 0.15, blue: 0.15)
        }
    }
}
#Preview {
    NavigationStack {
        GameModeSelectionView(path: .constant(NavigationPath()))
    }
}
