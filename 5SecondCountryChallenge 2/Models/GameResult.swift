import Foundation

struct GameResult: Codable, Hashable {
    let score: Int
    let correct: Int
    let wrong: Int
    let total: Int
    let xpEarned: Int
    let bestStreak: Int
    let mode: GameMode
    let difficulty: Difficulty

    var accuracy: Double { guard total > 0 else { return 0 }; return Double(correct) / Double(total) }
    var accuracyPercent: Int { Int(accuracy * 100) }
    var motivationalMessage: String {
        switch accuracyPercent {
        case 90...: return "Geography Master!"
        case 70...: return "Great Job!"
        case 50...: return "Good Progress!"
        default:    return "Keep Practicing!"
        }
    }
    var motivationalEmoji: String {
        switch accuracyPercent {
        case 90...: return "\u{1F3C6}"
        case 70...: return "\u{1F31F}"
        case 50...: return "\u{1F4C8}"
        default:    return "\u{1F4AA}"
        }
    }
}
