import UIKit
import SnapKit
import RxSwift

class ViewController: UIViewController {

    let bag = DisposeBag()
    let viewModel = GameListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.universes.asObservable()
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: bag)

        viewModel.newestGames.asObservable()
            .subscribe(onNext: {
                print("----------------------")
                print($0)
            })
            .disposed(by: bag)

        viewModel.fetchGames()
        viewModel.selectedUniverse.value = "Pokemon"
    }
}

