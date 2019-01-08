import Foundation
import Moya
import Alamofire

enum ApiService {
    case gameList
}

extension ApiService: TargetType {

    //For local tests, run local server
    var baseURL: URL { return URL(string: "https://parseapi.back4app.com/")! }

    var path: String {
        switch self {
        case .gameList:
            return "classes/Product"
        }
    }

    var method: Moya.Method {
        switch self {
        case .gameList:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .gameList:
            return .requestPlain
        }
    }

    var sampleData: Data {
        switch self {
        case .gameList:
            return "{\"results\":[{\"objectId\":\"90tZr7B7eJ\",\"name\":\"Mewtwo\",\"createdAt\":\"2018-06-19T19:13:19.646Z\",\"updatedAt\":\"2018-07-06T16:46:18.292Z\",\"price\":\"59,99\",\"imageURL\":\"https://www.smashbros.com/wiiu-3ds/images/character/mewtwo/main.png\",\"popular\":true,\"rating\":\"5\",\"downloads\":\"123123\",\"description\":\"it can be KO'd early.\",\"SKU\":\"234234234\",\"universe\":\"Pokemon\",\"kind\":\"Pokemon\"}]}".utf8Encoded
        }
    }

    var headers: [String: String]? {
        return [
            "Content-type": "application/json",
            "X-Parse-Application-Id": "I9pG8SLhTzFA0ImFkXsEvQfXMYyn0MgDBNg10Aps",
            "X-Parse-REST-API-Key": "Yvd2eK2LODfwVmkjQVNzFXwd3N0X7oUuwiMI3VDZ"
        ]
    }
}
// MARK: - Helpers
public extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

