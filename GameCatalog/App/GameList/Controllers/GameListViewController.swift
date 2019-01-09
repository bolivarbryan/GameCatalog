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
        self.view.backgroundColor = .red
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

        viewModel.universes.asObservable()
        .bind(to: filterView.categories)
        .disposed(by: bag)

        view.addSubview(gameListView)
        gameListView.snp.makeConstraints {
            $0.top.equalTo(filterView.snp.bottom)
            $0.right.left.equalToSuperview()
            $0.height.equalTo(140)
        }

        viewModel.newestGames.asObservable()
            .map({$0.map { $0.name }})
            .bind(to: gameListView.data)
            .disposed(by: bag)

    }
}
