import SwiftUI

@main
struct FiveSecondCountryChallengeApp: App {
    @StateObject private var progressViewModel = ProgressViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(progressViewModel)
                .environmentObject(settingsViewModel)
        }
    }
}
