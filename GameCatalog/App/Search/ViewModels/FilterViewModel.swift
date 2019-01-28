import Foundation

class FilterViewModel: CustomDebugStringConvertible {

    enum SortingMode: String {
        case downloads = "Downloads"
        case dateAdded = "Date added"
        case price = "Price"
    }

    static let minValue: Double = 19.99
    static let maxValue: Double = 199.99

    var categorySelected: SortingMode = .price
    var priceRange: (min: Double, max: Double) = (min: FilterViewModel.minValue, max: FilterViewModel.maxValue)
    var ratesSelected: Set<Int> = []
    var universes: [String]
    var selectedUniverse: String?

    func filterGames(from games: [Game]) -> [Game]{
        var results = games

        results = results
            .filter({ $0.priceValue >= priceRange.min })
            .filter({ $0.priceValue <= priceRange.max })
            .filter({
                guard
                    let universe = selectedUniverse
                    else { return true }
                return $0.universe == universe
            })
            .filter({
                guard
                    ratesSelected.count > 0
                    else { return true }
                return ratesSelected.contains($0.rateValue)
            })
            .sorted(by: { (lhs, rhs) -> Bool in
                switch categorySelected {
                case .downloads:
                    return lhs.downloadsValue >= rhs.downloadsValue
                case .dateAdded:
                    return lhs.createdDate >= rhs.createdDate
                case .price:
                    return lhs.priceValue >= rhs.priceValue
                }
            })

        return results
    }

    init(universes: [String]) {
        self.universes = universes
    }

    func addOrRemoveRateValue(_ newValue: Int) {
        switch ratesSelected.contains(newValue) {
        case true:
            ratesSelected.remove(6 - newValue)
        case false:
            ratesSelected.insert(6 - newValue)
        }
    }

    var debugDescription: String {
        return "Range: \(self.priceRange) \nCategory: \(String(describing: categorySelected)) \nRates:\(ratesSelected) \nUniverses:\(selectedUniverse)"
    }
}
