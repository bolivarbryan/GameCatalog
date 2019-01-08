import Foundation

struct Game: Codable {
    let objectID, name, createdAt, updatedAt: String
    let price: String
    let imageURL: String
    let popular: Bool
    let rating, downloads, description, sku: String
    let universe, kind: String

    enum CodingKeys: String, CodingKey {
        case objectID = "objectId"
        case name, createdAt, updatedAt, price, imageURL, popular, rating, downloads, description
        case sku = "SKU"
        case universe, kind
    }
}

//Used for easy parsing on API response
struct Games: Codable {
    let results: [Game]
}
