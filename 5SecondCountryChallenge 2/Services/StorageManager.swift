import Foundation

final class StorageManager {
    static let shared = StorageManager()
    private init() {}
    private let d = UserDefaults.standard

    private enum K {
        static let totalGamesPlayed = "totalGamesPlayed"
        static let totalCorrect     = "totalCorrect"
        static let totalWrong       = "totalWrong"
        static let bestStreak       = "bestStreak"
        static let totalXP          = "totalXP"
        static let bestScore        = "bestScore"
        static let flagRounds       = "flagRoundsPlayed"
        static let mapRounds        = "mapRoundsPlayed"
        static let badges           = "badges"
        static let leaderboard      = "leaderboard"
        static let soundEnabled     = "soundEnabled"
        static let hapticEnabled    = "hapticEnabled"
        static let timerDuration    = "timerDuration"
    }

    var totalGamesPlayed: Int { get { d.integer(forKey: K.totalGamesPlayed) } set { d.set(newValue, forKey: K.totalGamesPlayed) } }
    var totalCorrect:     Int { get { d.integer(forKey: K.totalCorrect) }     set { d.set(newValue, forKey: K.totalCorrect) } }
    var totalWrong:       Int { get { d.integer(forKey: K.totalWrong) }       set { d.set(newValue, forKey: K.totalWrong) } }
    var bestStreak:       Int { get { d.integer(forKey: K.bestStreak) }       set { d.set(newValue, forKey: K.bestStreak) } }
    var totalXP:          Int { get { d.integer(forKey: K.totalXP) }          set { d.set(newValue, forKey: K.totalXP) } }
    var bestScore:        Int { get { d.integer(forKey: K.bestScore) }        set { d.set(newValue, forKey: K.bestScore) } }
    var flagRoundsPlayed: Int { get { d.integer(forKey: K.flagRounds) }       set { d.set(newValue, forKey: K.flagRounds) } }
    var mapRoundsPlayed:  Int { get { d.integer(forKey: K.mapRounds) }        set { d.set(newValue, forKey: K.mapRounds) } }

    var soundEnabled:  Bool { get { d.object(forKey: K.soundEnabled)  as? Bool ?? true  } set { d.set(newValue, forKey: K.soundEnabled) } }
    var hapticEnabled: Bool { get { d.object(forKey: K.hapticEnabled) as? Bool ?? true  } set { d.set(newValue, forKey: K.hapticEnabled) } }
    var timerDuration: Int  { get { d.object(forKey: K.timerDuration) as? Int  ?? 5     } set { d.set(newValue, forKey: K.timerDuration) } }

    var level: Int { max(1, totalXP / 500 + 1) }
    var xpForNextLevel: Int { level * 500 }
    var xpProgress: Double {
        let base = Double((level - 1) * 500)
        let next = Double(level * 500)
        let range = next - base
        guard range > 0 else { return 1 }
        return (Double(totalXP) - base) / range
    }
    var overallAccuracy: Double {
        let t = totalCorrect + totalWrong
        guard t > 0 else { return 0 }
        return Double(totalCorrect) / Double(t)
    }

    var badges: [Badge] {
        get {
            guard let data = d.data(forKey: K.badges),
                  let decoded = try? JSONDecoder().decode([Badge].self, from: data) else { return Badge.allBadges }
            return decoded
        }
        set { if let e = try? JSONEncoder().encode(newValue) { d.set(e, forKey: K.badges) } }
    }
    func unlockBadge(id: String) {
        var b = badges
        if let i = b.firstIndex(where: { $0.id == id }), !b[i].isUnlocked { b[i].isUnlocked = true; badges = b }
    }

    var leaderboard: [LeaderboardEntry] {
        get {
            guard let data = d.data(forKey: K.leaderboard),
                  let decoded = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) else { return [] }
            return decoded.sorted { $0.score > $1.score }
        }
        set { if let e = try? JSONEncoder().encode(newValue) { d.set(e, forKey: K.leaderboard) } }
    }
    func addLeaderboardEntry(_ entry: LeaderboardEntry) {
        var c = leaderboard; c.append(entry)
        leaderboard = Array(c.sorted { $0.score > $1.score }.prefix(20))
    }
    func resetProgress() {
        let keep: [String: Any?] = [K.soundEnabled: d.object(forKey: K.soundEnabled),
                                    K.hapticEnabled: d.object(forKey: K.hapticEnabled),
                                    K.timerDuration: d.object(forKey: K.timerDuration)]
        d.removePersistentDomain(forName: Bundle.main.bundleIdentifier ?? "")
        keep.forEach { if let v = $0.value { d.set(v, forKey: $0.key) } }
    }
}
