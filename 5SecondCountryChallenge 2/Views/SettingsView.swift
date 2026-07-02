import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsVM: SettingsViewModel
    @EnvironmentObject var progressVM: ProgressViewModel
    @State private var showResetAlert = false

    var body: some View {
        ZStack {
            // Background
            GeometryReader { geo in
                if UIImage(named: "bg_settings") != nil {
                    Image("bg_settings", bundle: .main)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .ignoresSafeArea()
                } else {
                    LinearGradient(
                        colors: [
                            Color(red: 0.53, green: 0.81, blue: 0.95),
                            Color(red: 0.88, green: 0.95, blue: 1.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                }
            }
            .ignoresSafeArea()

            VStack(spacing: 7) {

                // MARK: - Header
                HStack(alignment: .bottom, spacing: 0) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Settings")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.06, green: 0.08, blue: 0.20))
                        Text("Customise your experience")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 0.35, green: 0.38, blue: 0.50))
                    }
                    .padding(.leading, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 50)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    if UIImage(named: "character_globe_gear") != nil {
                        Image("character_globe_gear", bundle: .main)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160, height: 220)
                            .offset(y: 40)
                            .padding(.trailing, 30)
                    }
                }

                // MARK: - All content — no scroll, fits on screen
                VStack(spacing: 15) {

                    // GAMEPLAY
                    sectionHeader("GAMEPLAY", icon: "gamecontroller.fill",
                                  color: Color(red: 0.1, green: 0.65, blue: 0.55))

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "timer.circle")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color(red: 0.1, green: 0.65, blue: 0.55))
                            Text("Timer Duration")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Color(red: 0.06, green: 0.08, blue: 0.20))
                            Spacer()
                            Text("\(settingsVM.timerDuration)s")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(red: 0.1, green: 0.65, blue: 0.55))
                        }

                        HStack(spacing: 10) {
                            ForEach([3, 5, 10], id: \.self) { secs in
                                Button {
                                    HapticManager.shared.selectionChanged()
                                    settingsVM.timerDuration = secs
                                } label: {
                                    Text("\(secs)s")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(
                                            settingsVM.timerDuration == secs
                                            ? .white
                                            : Color(red: 0.1, green: 0.65, blue: 0.55)
                                        )
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .fill(
                                                    settingsVM.timerDuration == secs
                                                    ? Color(red: 0.1, green: 0.65, blue: 0.55)
                                                    : Color(red: 0.1, green: 0.65, blue: 0.55).opacity(0.12)
                                                )
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(14)
                    .background(cardBackground)
                    .padding(.horizontal, 16)

                    // FEEDBACK
                    sectionHeader("FEEDBACK", icon: "bubble.left.fill",
                                  color: Color(red: 0.55, green: 0.25, blue: 0.90))

                    VStack(spacing: 0) {
                        compactToggleRow(
                            title: "Sound Effects",
                            subtitle: "Fun sounds and effects",
                            icon: "speaker.wave.2.fill",
                            iconColor: Color(red: 0.55, green: 0.25, blue: 0.90),
                            value: $settingsVM.soundEnabled
                        )
                        Divider().padding(.horizontal, 14)
                        compactToggleRow(
                            title: "Haptic Feedback",
                            subtitle: "Vibration for actions",
                            icon: "iphone.radiowaves.left.and.right",
                            iconColor: Color(red: 0.55, green: 0.25, blue: 0.90),
                            value: $settingsVM.hapticEnabled
                        )
                    }
                    .background(cardBackground)
                    .padding(.horizontal, 16)

                    // PROGRESS
                    sectionHeader("PROGRESS", icon: "chart.bar.fill",
                                  color: Color(red: 0.95, green: 0.55, blue: 0.15))

                    Button {
                        HapticManager.shared.impact(.heavy)
                        showResetAlert = true
                    } label: {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.95, green: 0.22, blue: 0.22).opacity(0.12))
                                    .frame(width: 38, height: 38)
                                Image(systemName: "trash.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color(red: 0.95, green: 0.22, blue: 0.22))
                            }
                            VStack(alignment: .leading, spacing: 1) {
                                Text("Reset All Progress")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Color(red: 0.95, green: 0.22, blue: 0.22))
                                Text("This will remove all your progress")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(Color(red: 0.95, green: 0.22, blue: 0.22).opacity(0.7))
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(red: 0.95, green: 0.22, blue: 0.22).opacity(0.5))
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color(red: 0.95, green: 0.22, blue: 0.22).opacity(0.07))
                                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 3)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 16)

                    // ABOUT
                    sectionHeader("ABOUT", icon: "info.circle.fill",
                                  color: Color(red: 0.15, green: 0.45, blue: 0.95))

                    VStack(spacing: 0) {
                        compactAboutRow(title: "App Version", value: "1.0.0",
                                        iconName: "settings_version",
                                        iconColor: Color(red: 0.15, green: 0.45, blue: 0.95),
                                        fallbackIcon: "globe")
                        Divider().padding(.horizontal, 14)
                        compactAboutRow(title: "Countries", value: "\(CountryDatabase.all.count)",
                                        iconName: "settings_countries",
                                        iconColor: Color(red: 0.15, green: 0.70, blue: 0.35),
                                        fallbackIcon: "globe.grid.2x2.fill")
                        Divider().padding(.horizontal, 14)
                        compactAboutRow(title: "Built With", value: "SwiftUI · iOS 17+",
                                        iconName: "settings_builtwith",
                                        iconColor: Color(red: 0.95, green: 0.25, blue: 0.45),
                                        fallbackIcon: "heart.fill")
                    }
                    .background(cardBackground)
                    .padding(.horizontal, 16)
                }

                Spacer(minLength: 90)
            }
        }
        .alert("Reset All Progress?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                settingsVM.resetProgress(progressVM: progressVM)
            }
        } message: {
            Text("This will permanently delete all your scores, XP, and badges. This action cannot be undone.")
        }
    }

    // MARK: - Card background
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(Color.white)
            .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
    }

    // MARK: - Section Header
    private func sectionHeader(_ title: String, icon: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(color)
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(color)
                .tracking(0.5)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 6)
    }

    // MARK: - Compact Toggle Row
    private func compactToggleRow(
        title: String,
        subtitle: String,
        icon: String,
        iconColor: Color,
        value: Binding<Bool>
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(iconColor)
                .frame(width: 26)
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(red: 0.06, green: 0.08, blue: 0.20))
                Text(subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(red: 0.50, green: 0.52, blue: 0.60))
            }
            Spacer()
            Toggle("", isOn: value)
                .tint(iconColor)
                .labelsHidden()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }

    // MARK: - Compact About Row
    private func compactAboutRow(
        title: String,
        value: String,
        iconName: String,
        iconColor: Color,
        fallbackIcon: String
    ) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(iconColor)
                    .frame(width: 34, height: 34)
                if UIImage(named: iconName) != nil {
                    Image(iconName, bundle: .main)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                } else {
                    Image(systemName: fallbackIcon)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color(red: 0.06, green: 0.08, blue: 0.20))
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color(red: 0.50, green: 0.52, blue: 0.60))
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color(red: 0.75, green: 0.77, blue: 0.82))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsViewModel())
        .environmentObject(ProgressViewModel())
}
