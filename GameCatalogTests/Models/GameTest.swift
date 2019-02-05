import XCTest
@testable import GameCatalog

class GameTest: XCTestCase {

    override func setUp() { }

    override func tearDown() { }

    func testCreatedAtStringIsADate() {
        let jsonString = """
                        {
                        "objectId": "90tZr7B7eJ",
                        "name": "Mewtwo",
                        "createdAt": "2018-06-19T19:13:19.646Z",
                        "updatedAt": "2018-07-06T16:46:18.292Z",
                        "price": "59,99",
                        "imageURL": "https://www.smashbros.com/wiiu-3ds/images/character/mewtwo/main.png",
                        "popular": true,
                        "rating": "5",
                        "downloads": "123123",
                        "description": "Mewtwo is a downloadable character for Super Smash Bros. for Nintendo 3DS and Wii U. It was confirmed in a Nintendo Direct on October 23, 2014. It was a part of the \"Super Smash Bros. Offer\" free DLC promotion obtainable by registering both the Wii U and 3DS versions of the game in Club Nintendo by March 31st 2015. For non-Club Nintendo Members, Mewtwo was released as paid DLC on April 28th, 2015 for £3.49 ($3.99) or for £4.49 ($4.99) on both games.\n\nIt currently ranks 10th on the tier list due to having a strong projectile, amazing mobility, and a solid game both on the ground and in the air. However, they are the second lightest character in the game, meaning it can be KO'd early.",
                        "SKU": "234234234",
                        "universe": "Pokemon",
                        "kind": "Pokemon"
                        }
"""
        guard
            let data = jsonString.data(using: .utf8)
            else { fatalError("Json string not encode, check mock") }

        do {
            let game = try JSONDecoder().decode(Game.self, from: data)
            let defaultDate = Date(timeIntervalSince1970: 0)
            XCTAssertNotEqual(game.createdDate, defaultDate, "Input date never should be nil")
        } catch {
            assertionFailure("Model decoding failed")
        }



    }

}
