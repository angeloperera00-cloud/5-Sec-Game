import Foundation

struct LeaderboardEntry: Identifiable, Codable {
    let id: UUID
    let score: Int
    let mode: GameMode
    let difficulty: Difficulty
    let accuracy: Double
    let date: Date

    var formattedDate: String {
        let f = DateFormatter(); f.dateStyle = .medium; return f.string(from: date)
    }
    var accuracyPercent: String { "\(Int(accuracy * 100))%" }
}
