import UIKit
import RxSwift

class GameListViewController: UIViewController {

    //MARK: - Properties
    let headerView: HeaderView = HeaderView(title: .navigationTitleGames,
                                        rightAction: .filter)

    let filterView: CategoriesListView = CategoriesListView(datasource: [])

    let gameListView  = GamesListView()

    let bag = DisposeBag()
    let viewModel = GameListViewModel()

    //MARK: - Initializer

    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.fetchGames()
        viewModel.delegate = self
    }

    //MARK: - Functions

    func configureUI() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
        }
        headerView.backgroundColor = .white

        headerView.rightButton.rx.tap.asObservable()
            .subscribe(onNext:{ _ in
                let vc = FilterViewController(universes: self.viewModel.universes.value)
                let nc = UINavigationController(rootViewController: vc)
                self.present(nc, animated: true, completion: nil)
            })
        .disposed(by: bag)

        view.addSubview(filterView)
        filterView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.right.left.equalToSuperview()
        }
        filterView.backgroundColor = .black

        filterView.collectionView.rx.modelSelected(String.self)
            .subscribe(onNext:{
                self.viewModel.selectedUniverse = $0
            })
            .disposed(by: bag)

        viewModel.universes.asObservable()
        .bind(to: filterView.categories)
        .disposed(by: bag)

        view.addSubview(gameListView)
        gameListView.snp.makeConstraints {
            $0.top.equalTo(filterView.snp.bottom).offset(10)
            $0.right.left.bottom.equalToSuperview()
        }

        gameListView.delegate = self
    }
}

extension GameListViewController: GameListViewModelDelegate {
    func didFetch() {
        gameListView.newestGames = viewModel.newestGames
        gameListView.mostPopularGames = viewModel.mostPopularGames
        gameListView.allGames = viewModel.filteredGames
    }
}

extension GameListViewController: GameListViewDelegate {
    func didSelectGame(game: Game) {
        print(game.name)
    }
}
