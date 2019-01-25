import Foundation

enum Language: String {
    case navigationTitleGames = "navigation.title.games"
    case newestGames = "games.newest"
    case popularGames = "games.popular"
    case allGames = "games.all"
    case filter = "filter"
    case downloads = "filter.downloads"


    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: self.rawValue)
    }
}
