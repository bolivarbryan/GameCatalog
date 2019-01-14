import Foundation
import UIKit

struct Game: Codable {
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

    var createdDate: Date {
        return GCDateFormatter.iso8601.formatter().date(from: createdAt) ?? Date()
    }

    var imageSource: URL? {
        return URL(string: imageURL)
    }

    enum CodingKeys: String, CodingKey {
        case name, createdAt, updatedAt, price, imageURL, popular, rating, downloads, description, universe, kind
        case objectID = "objectId"
        case sku = "SKU"
    }
}

//Used for easy parsing on API response
struct Games: Codable {
    let results: [Game]
}
