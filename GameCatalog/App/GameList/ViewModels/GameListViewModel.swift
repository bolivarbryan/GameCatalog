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

class GameListViewModel {
    static let allUniversesKey = "All"

    //MARK: - Properties
    private let games: Variable<[Game]> = Variable([])
    let filteredGames: Variable<[Game]> = Variable([])
    let newestGames: Variable<[Game]> = Variable([])
    let mostPopularGames: Variable<[Game]> = Variable([])
    let universes: Variable<[String]> = Variable([])
    let selectedUniverse: Variable<String>
    let bag: DisposeBag = DisposeBag()

    //MARK: - Initializer
    init() {
        selectedUniverse = Variable(GameListViewModel.allUniversesKey)
        observeNewGames()
        observeMostPopularGames()
        buildUniverseListFromGames()
        listVisibleGamesFromFilter()
    }

    //MARK: - Functions

    func observeNewGames() {
        filteredGames.asObservable()
            .subscribe(onNext: { [weak self] in

                let gms = $0.sorted(by: { (game1, game2) -> Bool in
                    game1.createdDate < game2.createdDate
                })

                let top = (gms.count > 5) ? 5 : (gms.count - 1)
                guard top > 0 else { return }

                self?.newestGames.value = Array(gms[0...(top - 1)])
            })
            .disposed(by: bag)
    }

    func observeMostPopularGames() {
        filteredGames.asObservable()
            .map ({ gamesObject in gamesObject.filter({ $0.popular == true })})
            .subscribe(onNext: { [weak self] in
                self?.mostPopularGames.value = $0
            })
            .disposed(by: bag)
    }

    func buildUniverseListFromGames() {
        filteredGames.asObservable()
            .map ({ $0.map({ game in game.universe }) })
            .map ({Array(Set($0))})
            .map({
                var universesObject = [GameListViewModel.allUniversesKey]
                universesObject.append(contentsOf: $0)
                return universesObject
            })
            .bind(to: universes)
            .disposed(by: bag)
    }

    func listVisibleGamesFromFilter() {
        selectedUniverse.asObservable()
            .subscribe(onNext: { selectedUniverseObject in
                self.games.asObservable()
                    .map ({ gamesObject in
                        gamesObject
                            .filter({ game in
                                if selectedUniverseObject == GameListViewModel.allUniversesKey { return true }
                                return game.universe == selectedUniverseObject
                            })
                    })
                    .bind(to: self.filteredGames)
                    .disposed(by: self.bag)
            })
            .disposed(by: bag)
    }

    func fetchGames() {
        let provider = MoyaProvider<ApiService>()
        provider.request(.gameList) { (result) in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                do {
                    let games = try JSONDecoder().decode(Games.self, from: data)
                    self.games.value = games.results
                } catch {
                    print(error.localizedDescription)
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
