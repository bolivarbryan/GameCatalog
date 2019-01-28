import Foundation

class FilterViewModel: CustomDebugStringConvertible {
    static let minValue: Double = 19.99
    static let maxValue: Double = 199.99

    var categorySelected: String? = nil
    var priceRange: (Double, Double) = (FilterViewModel.minValue, FilterViewModel.maxValue)
    var ratesSelected: Set<Int> = []
    var universes: [String]
    var selectedUniverse: String?

    init(universes: [String]) {
        self.universes = universes
    }

    func addOrRemoveRateValue(_ newValue: Int) {
        switch ratesSelected.contains(newValue) {
        case true:
            ratesSelected.remove(newValue)
        case false:
            ratesSelected.insert(newValue)
        }
    }

    var debugDescription: String {
        return "Range: \(self.priceRange) \nCategory: \(String(describing: categorySelected)) \nRates:\(ratesSelected) \nUniverses:\(selectedUniverse)"
    }
}
