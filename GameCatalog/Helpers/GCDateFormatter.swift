import Foundation

enum GCDateFormatter: String {

    case iso8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    func formatter() -> DateFormatter {
        let df = DateFormatter()
        df.dateFormat = self.rawValue
        return df
    }

}
