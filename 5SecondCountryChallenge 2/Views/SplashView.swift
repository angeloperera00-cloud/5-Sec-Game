import SwiftUI

struct SplashView: View {
    @EnvironmentObject var progressVM: ProgressViewModel
    @EnvironmentObject var settingsVM: SettingsViewModel

    @State private var showHome = false
    @State private var contentOpacity: Double = 0
    @State private var loadingProgress: CGFloat = 0

    var body: some View {
        if showHome {
            HomeView().transition(.opacity)
        } else {
            GeometryReader { geo in
                ZStack {
                    // Fallback background color
                    Color(red: 0.53, green: 0.81, blue: 0.92)
                        .ignoresSafeArea()

                    // Full screen background image
                    Image("splash_bg", bundle: .main)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width * 1.03, height: geo.size.height)
                        .clipped()
                        .ignoresSafeArea()

                    // Bottom content
                    VStack {
                        Spacer()

                        VStack(spacing: 14) {

                            // MARK: - Premium Loading Bar
                            ZStack(alignment: .leading) {

                                // Outer black border container
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .fill(Color.black.opacity(0.75))
                                    .frame(height: 38)

                                // Inner track (glass effect)
                                RoundedRectangle(cornerRadius: 27, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.25),
                                                Color.white.opacity(0.10)
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(height: 30)
                                    .padding(.horizontal, 4)

                                // Gold fill bar
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 1.0, green: 0.92, blue: 0.3),
                                                Color(red: 1.0, green: 0.75, blue: 0.0),
                                                Color(red: 0.95, green: 0.60, blue: 0.0)
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(
                                        width: max(30, (geo.size.width - 80) * loadingProgress),
                                        height: 30
                                    )
                                    .padding(.horizontal, 4)
                                    .shadow(color: Color.orange.opacity(0.6), radius: 6, x: 0, y: 3)
                                    .overlay(
                                        // Shine highlight on top of fill
                                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        Color.white.opacity(0.45),
                                                        Color.clear
                                                    ],
                                                    startPoint: .top,
                                                    endPoint: .center
                                                )
                                            )
                                            .padding(.horizontal, 4)
                                            .frame(height: 15)
                                            .frame(maxHeight: .infinity, alignment: .top)
                                    )
                            }
                            .frame(height: 38)
                            // Outer glow shadow
                            .shadow(color: Color.black.opacity(0.35), radius: 8, x: 0, y: 4)
                            .shadow(color: Color.orange.opacity(0.2), radius: 12, x: 0, y: 2)

                            // Loading text
                            Text("Loading your adventure...")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.6), radius: 3, x: 0, y: 1)
                        }
                        .opacity(contentOpacity)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 54)
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeIn(duration: 0.5).delay(0.3)) {
                    contentOpacity = 1.0
                }
                withAnimation(.easeInOut(duration: 2.0).delay(0.4)) {
                    loadingProgress = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showHome = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(ProgressViewModel())
        .environmentObject(SettingsViewModel())
}
