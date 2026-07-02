import Foundation

enum AppRoute: Hashable {
    case home
    case gameModeSelection
    case difficultySelection(mode: GameMode)
    case quiz(mode: GameMode, difficulty: Difficulty)
    case result(result: GameResult)
    case progress
    case badges
    case leaderboard
    case settings
}
