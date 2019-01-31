import Foundation
import CouchbaseLiteSwift

struct DatabaseManager {

    static let shared = DatabaseManager()
    static private let databaseName = "gamecatalog"
    let database: Database

    enum DocumentType {
        case game
    }

    private init() {
        do {
            database = try Database(name: DatabaseManager.databaseName)
        } catch {
            fatalError("Error opening database")
        }
    }
}
