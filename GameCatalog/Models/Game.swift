import Foundation
import UIKit

struct Game: Codable {
    let objectID, name, createdAt, updatedAt: String
    let price: String
    let imageURL: String
    let popular: Bool
    let rating, downloads, description, sku: String
    let universe, kind: String

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
