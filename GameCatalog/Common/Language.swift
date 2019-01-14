import Foundation

enum Language: String {
    case navigationTitleGames = "navigation.title.games"
    case newestGames = "games.newest"
    case popularGames = "games.popular"
    case allGames = "games.all"

    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: self.rawValue)
    }
}
