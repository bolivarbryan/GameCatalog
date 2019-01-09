import Foundation

enum Language: String {
    case navigationTitleGames = "navigation.title.games"

    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: self.rawValue)
    }
}
