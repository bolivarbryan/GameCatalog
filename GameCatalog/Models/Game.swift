import Foundation
import UIKit
import CouchbaseLiteSwift

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
    
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let number = NSNumber(value: priceValue)
        return formatter.string(from: number)!
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

    init(from result: ResultSet.Element) {
        self.objectID = result.string(forKey: "objectId") ?? ""
        self.name = result.string(forKey: "name") ?? ""
        self.createdAt = result.string(forKey: "createdAt") ?? ""
        self.updatedAt = result.string(forKey: "updatedAt") ?? ""
        self.price = result.string(forKey: "price") ?? ""
        self.imageURL = result.string(forKey: "imageURL") ?? ""
        self.popular = result.boolean(forKey: "popular") 
        self.rating = result.string(forKey: "rating") ?? ""
        self.downloads = result.string(forKey: "downloads") ?? ""
        self.description = result.string(forKey: "description") ?? ""
        self.sku = result.string(forKey: "SKU") ?? ""
        self.universe = result.string(forKey: "universe") ?? ""
        self.kind = result.string(forKey: "kind") ?? ""
    }
}

//Used for easy parsing on API response
class Games: Codable {
    let results: [Game]
}

extension Game {
    var mutableDocument: MutableDocument {
        return MutableDocument()
            .setString(objectID, forKey: "objectId")
            .setString(name, forKey: "name")
            .setString(createdAt, forKey: "createdAt")
            .setString(updatedAt, forKey: "updatedAt")
            .setString(price, forKey: "price")
            .setString(imageURL, forKey: "imageURL")
            .setBoolean(popular, forKey: "popular")
            .setString(rating, forKey: "rating")
            .setString(downloads, forKey: "downloads")
            .setString(description, forKey: "description")
            .setString(sku, forKey: "SKU")
            .setString(universe, forKey: "universe")
            .setString(kind, forKey: "kind")
    }
}

extension Game: Equatable {
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.objectID == rhs.objectID
    }
}
