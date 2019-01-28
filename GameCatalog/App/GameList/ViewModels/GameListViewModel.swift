import Foundation
import RxCocoa
import RxSwift
import Moya

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

        }
    }

    var filteredGames: [Game] = [] {
        didSet {
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
        let provider = MoyaProvider<ApiService>()
        provider.request(.gameList) { (result) in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                do {
                    let games = try JSONDecoder().decode(Games.self, from: data)
                    self.games = games.results
                } catch {
                    print(error.localizedDescription)
                }
                self.delegate?.didFetch()
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
}
