import SwiftUI

final class SettingsViewModel: ObservableObject {
    private let s = StorageManager.shared
    @Published var soundEnabled:  Bool { didSet { s.soundEnabled  = soundEnabled } }
    @Published var hapticEnabled: Bool { didSet { s.hapticEnabled = hapticEnabled } }
    @Published var timerDuration: Int  { didSet { s.timerDuration = timerDuration } }
    init() { soundEnabled = s.soundEnabled; hapticEnabled = s.hapticEnabled; timerDuration = s.timerDuration }
    func resetProgress(progressVM: ProgressViewModel) { s.resetProgress(); progressVM.refresh() }
}
