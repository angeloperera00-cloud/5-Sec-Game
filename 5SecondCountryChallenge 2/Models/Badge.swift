import Foundation

struct Badge: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let icon: String
    var isUnlocked: Bool

    static let allBadges: [Badge] = [
        Badge(id: "first_game",       name: "First Steps",       description: "Complete your first game",              icon: "gamecontroller.fill",      isUnlocked: false),
        Badge(id: "first_correct",    name: "Sharp Eye",         description: "Get your first correct answer",         icon: "checkmark.seal.fill",      isUnlocked: false),
        Badge(id: "correct_10",       name: "Getting Warmed Up", description: "Answer 10 questions correctly",         icon: "flame.fill",               isUnlocked: false),
        Badge(id: "correct_50",       name: "Geography Buff",    description: "Answer 50 questions correctly",         icon: "globe.americas.fill",      isUnlocked: false),
        Badge(id: "perfect_round",    name: "Flawless",          description: "Score 100% in a round",                 icon: "trophy.fill",              isUnlocked: false),
        Badge(id: "flag_master",      name: "Flag Master",       description: "Complete 5 Flag Challenge rounds",      icon: "flag.fill",                isUnlocked: false),
        Badge(id: "map_explorer",     name: "Map Explorer",      description: "Complete 5 Map Challenge rounds",       icon: "map.fill",                 isUnlocked: false),
        Badge(id: "speed_genius",     name: "Speed Genius",      description: "Answer within 1 second 5 times",       icon: "bolt.fill",                isUnlocked: false),
        Badge(id: "daily_challenger", name: "Daily Challenger",  description: "Complete the daily challenge",          icon: "calendar.badge.checkmark", isUnlocked: false),
        Badge(id: "streak_5",         name: "On Fire",           description: "Reach a 5-answer streak",              icon: "flame.circle.fill",        isUnlocked: false),
        Badge(id: "streak_10",        name: "Unstoppable",       description: "Reach a 10-answer streak",             icon: "star.circle.fill",         isUnlocked: false),
        Badge(id: "world_master",     name: "World Master",      description: "Complete a World Master difficulty round", icon: "crown.fill",           isUnlocked: false),
    ]
}
