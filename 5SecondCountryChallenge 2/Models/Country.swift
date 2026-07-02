import Foundation

struct Country: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let flag: String
    let continent: Continent
    let difficulty: Difficulty
    let mapAssetName: String
    let shortFact: String

    enum Continent: String, Codable, CaseIterable {
        case europe        = "Europe"
        case northAmerica  = "North America"
        case southAmerica  = "South America"
        case asia          = "Asia"
        case africa        = "Africa"
        case oceania       = "Oceania"
        case middleEast    = "Middle East"
    }
}
