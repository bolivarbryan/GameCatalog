import Foundation
import UIKit

class Game: Codable, CustomDebugStringConvertible {

    let objectID: String
    let name: String
    let createdAt: String
    let updatedAt: String
    let price: String
    let imageURL: String
    let popular: Bool
    let rating: String
    let downloads: String
    let description: String
    let sku: String
    let universe, kind: String

    var priceValue: Double {
        return Double(price.replacingOccurrences(of: ",", with: ".") ) ?? 0
    }

    var rateValue: Int {
        return Int(rating) ?? 0
    }

    var downloadsValue: Int {
        return Int(downloads) ?? 0
    }

    var createdDate: Date {
        return GCDateFormatter.iso8601.formatter().date(from: createdAt) ?? Date(timeIntervalSince1970: 0)
    }

    var imageSource: URL? {
        return URL(string: imageURL)
    }

    enum CodingKeys: String, CodingKey {
        case name, createdAt, updatedAt, price, imageURL, popular, rating, downloads, description, universe, kind
        case objectID = "objectId"
        case sku = "SKU"
    }

    var debugDescription: String {
        return "\(name) - price: \(priceValue) - rating: \(rateValue) - downloads:\(downloads) - created: \(createdAt)"
    }
}

//Used for easy parsing on API response
class Games: Codable {
    let results: [Game]
}
