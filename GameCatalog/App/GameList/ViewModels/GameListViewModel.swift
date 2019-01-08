import Foundation
import RxCocoa
import RxSwift
import Moya

class GameListViewModel {
    let games: Variable<[Game]> = Variable([])
    let newestGames: Variable<[Game]> = Variable([])
    let mostPopularGames: Variable<[Game]> = Variable([])

    let bag: DisposeBag = DisposeBag()

    init() {
        games.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.newestGames.value = $0
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
