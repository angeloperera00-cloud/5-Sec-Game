import Foundation

enum GameMode: String, CaseIterable, Codable, Hashable {
    case flag       = "Flag Challenge"
    case map        = "Map Challenge"
    case mixed      = "Mixed Challenge"
    case rush       = "60 Second Rush"

    var icon: String {
        switch self {
        case .flag:  return "flag.fill"
        case .map:   return "map.fill"
        case .mixed: return "shuffle"
        case .rush:  return "bolt.fill"
        }
    }

    var description: String {
        switch self {
        case .flag:  return "Identify countries from their flags"
        case .map:   return "Recognise countries by their shape"
        case .mixed: return "Flags and maps randomised each round"
        case .rush:  return "Answer as many as you can in 60 seconds"
        }
    }

    var difficultyLabel: String {
        switch self {
        case .flag:  return "Classic"
        case .map:   return "Expert"
        case .mixed: return "Advanced"
        case .rush:  return "Intense"
        }
    }

    var questionsPerRound: Int? {
        switch self {
        case .rush: return nil
        default:    return 10
        }
    }
}
