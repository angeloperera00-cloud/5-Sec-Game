import SwiftUI

final class ProgressViewModel: ObservableObject {
    private let s = StorageManager.shared
    @Published var totalGamesPlayed: Int = 0
    @Published var totalCorrect:     Int = 0
    @Published var totalWrong:       Int = 0
    @Published var bestStreak:       Int = 0
    @Published var level:            Int = 1
    @Published var totalXP:          Int = 0
    @Published var xpProgress:       Double = 0
    @Published var bestScore:        Int = 0
    @Published var overallAccuracy:  Double = 0
    @Published var badges:           [Badge] = []
    init() { refresh() }
    func refresh() {
        totalGamesPlayed = s.totalGamesPlayed; totalCorrect = s.totalCorrect
        totalWrong = s.totalWrong; bestStreak = s.bestStreak; level = s.level
        totalXP = s.totalXP; xpProgress = s.xpProgress; bestScore = s.bestScore
        overallAccuracy = s.overallAccuracy; badges = s.badges
    }
    var totalAnswered: Int { totalCorrect + totalWrong }
    var accuracyPercent: Int { Int(overallAccuracy * 100) }
    var xpForNextLevel: Int { s.xpForNextLevel }
}
