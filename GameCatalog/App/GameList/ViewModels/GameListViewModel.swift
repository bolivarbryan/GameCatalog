import Foundation
import RxCocoa
import RxSwift
import Moya
import CouchbaseLiteSwift

enum GameSection {
    case newest
    case popular
    case all
}

typealias GameSectionDatasource = Variable<[(section: GameSection, games: [Game])]>

protocol GameListViewModelDelegate {
    func didFetch()
}

class GameListViewModel {
    static let allUniversesKey = "All"
    
    //MARK: - Properties
    var games: [Game] = [] {
        didSet {
            if selectedUniverse == GameListViewModel.allUniversesKey {
                self.filteredGames = self.games
            } else {
                self.filteredGames = self.games.filter({ $0.universe == selectedUniverse })
            }

            //universes list
            var universesObject = [GameListViewModel.allUniversesKey]
            var sortedNames = games
                .map { $0.universe}

            sortedNames = Array(Set(sortedNames))
            .sorted(by: {$0 < $1})


            universesObject.append(contentsOf: sortedNames )

            universes.value = universesObject
            delegate?.didFetch()
        }
    }

    var filteredGames: [Game] = [] {
        didSet {
            guard
                filteredGames.count >= 1
            else {
                newestGames = []
                mostPopularGames = []
                return
            }

            //newest games
            let gms = filteredGames.sorted(by: { (game1, game2) -> Bool in
                game1.createdDate < game2.createdDate
            })

            let top = (gms.count > 5) ? 5 : (gms.count)
            newestGames = Array(gms[0...(top - 1)])
            mostPopularGames = filteredGames.filter({ $0.popular == true })
        }
    }

    var delegate: GameListViewModelDelegate? = nil
    var newestGames: [Game] = []
    var mostPopularGames: [Game] = []
    let universes: Variable<[String]> = Variable([])
    var selectedUniverse: String = GameListViewModel.allUniversesKey {
        didSet {
            reloadFilters()
        }
    }
    let bag: DisposeBag = DisposeBag()

    //MARK: - Initializer
    init() {
        selectedUniverse = GameListViewModel.allUniversesKey
    }

    func fetchGames() {
        loadGamesFromLocalDatabase()

        let provider = MoyaProvider<ApiService>()
        provider.request(.gameList) { (result) in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                do {
                    let games = try JSONDecoder().decode(Games.self, from: data)
                    self.storeGamesInLocalDatabase(newGames: games.results)
                    self.loadGamesFromLocalDatabase()
                } catch {
                    print(error.localizedDescription)
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    func reloadFilters() {
        filteredGames = games.filter({ game in
            if selectedUniverse == GameListViewModel.allUniversesKey { return true }
            return game.universe == selectedUniverse
        })
        delegate?.didFetch()
    }

    func storeGamesInLocalDatabase(newGames: [Game]) {
        try? DatabaseManager.shared.database.inBatch {
            for game in newGames {
                switch games.contains(game) {
                case true:
                    continue
                case false:
                    try? DatabaseManager.shared.database.saveDocument(game.mutableDocument)
                }

            }
        }
    }

    func loadGamesFromLocalDatabase() {
        let query = QueryBuilder
            .select(
                SelectResult.expression(Meta.id),
                SelectResult.property("objectId"),
                SelectResult.property("name"),
                SelectResult.property("createdAt"),
                SelectResult.property("updatedAt"),
                SelectResult.property("price"),
                SelectResult.property("imageURL"),
                SelectResult.property("popular"),
                SelectResult.property("rating"),
                SelectResult.property("downloads"),
                SelectResult.property("description"),
                SelectResult.property("SKU"),
                SelectResult.property("universe"),
                SelectResult.property("kind")
            )
            .from(DataSource.database(DatabaseManager.shared.database))
        do {
            var games: [Game] = []
            for result in try query.execute() {
                games.append(Game(from: result))
            }
            self.games = games
        } catch {
            print(error)
        }
    }

}
