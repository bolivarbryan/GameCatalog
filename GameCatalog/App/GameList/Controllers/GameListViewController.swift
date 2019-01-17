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
    }

    //MARK: - Functions

    func configureUI() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
        }
        headerView.backgroundColor = .white

        view.addSubview(filterView)
        filterView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.right.left.equalToSuperview()
        }
        filterView.backgroundColor = .black

        filterView.collectionView.rx.modelSelected(String.self)
            .subscribe(onNext:{
                self.viewModel.filterValue.value = $0
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

        viewModel.newestGames.asObservable()
            .bind(to: gameListView.newestGames)
            .disposed(by: bag)

        viewModel.filteredGames.asObservable()
            .bind(to: gameListView.allGames)
            .disposed(by: bag)

        viewModel.mostPopularGames.asObservable()
            .bind(to: gameListView.mostPopularGames)
            .disposed(by: bag)
    }
}
