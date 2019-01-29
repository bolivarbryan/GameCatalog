import UIKit
import RxSwift

class FilterResultsViewController: UIViewController {

    let headerView: HeaderView = HeaderView(title: .navigationTitleGames,
                                            rightAction: .clearFilter )

    let gameListView  = GamesListView()
    let viewModel: GameListViewModel
    let filtersViewModel: FilterViewModel
    let bag = DisposeBag()

    //MARK: - Initializer

    init(gamesViewModel: GameListViewModel, filterViewModel: FilterViewModel) {
        self.viewModel = gamesViewModel
        self.filtersViewModel = filterViewModel
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        gameListView.newestGames = []
        gameListView.mostPopularGames = []
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)


        view.addSubview(gameListView)
        gameListView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.right.left.bottom.equalToSuperview()
        }
        gameListView.allGamesCV.title = "Filtered"
        gameListView.delegate = self
        gameListView.allGames = filtersViewModel.filterGames(from: viewModel.games)
    }
}

extension FilterResultsViewController: GameListViewDelegate {
    func didSelectGame(game: Game) {
        let vc = GameDetailsViewController(game: game)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

