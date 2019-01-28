import Foundation

class FilterViewModel {
    static let minValue: Double = 19.99
    static let maxValue: Double = 199.99

    var categorySelected: String? = nil
    var priceRange: (Double, Double) = (FilterViewModel.minValue, FilterViewModel.maxValue)
    var ratesSelected: Set<Int> = []
    var universes: [String]

    init(universes: [String]) {
        self.universes = universes
    }
}
