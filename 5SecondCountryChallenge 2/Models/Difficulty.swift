import Foundation

enum Difficulty: String, CaseIterable, Codable, Hashable {
    case easy        = "Easy"
    case medium      = "Medium"
    case hard        = "Hard"
    case worldMaster = "World Master"

    var description: String {
        switch self {
        case .easy:        return "Popular & well-known countries"
        case .medium:      return "A balanced mix of nations"
        case .hard:        return "Lesser-known countries"
        case .worldMaster: return "Every country in the database"
        }
    }
    var recommendedFor: String {
        switch self {
        case .easy:        return "Beginners & casual players"
        case .medium:      return "Geography enthusiasts"
        case .hard:        return "Experienced players"
        case .worldMaster: return "Geography experts only"
        }
    }
    var multiplier: Double {
        switch self {
        case .easy: return 1.0; case .medium: return 1.5
        case .hard: return 2.0; case .worldMaster: return 3.0
        }
    }
    var multiplierLabel: String {
        switch self {
        case .easy: return "x1"; case .medium: return "x1.5"
        case .hard: return "x2"; case .worldMaster: return "x3"
        }
    }
    var icon: String {
        switch self {
        case .easy: return "star"; case .medium: return "star.leadinghalf.filled"
        case .hard: return "star.fill"; case .worldMaster: return "crown.fill"
        }
    }
}
