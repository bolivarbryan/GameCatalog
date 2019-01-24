import UIKit
import SnapKit
import RxSwift

protocol GameListViewDelegate {
    func didSelectGame(game: Game)
}

class GamesListView: UIView {
    var newestGames: [Game] = [] {
        didSet {
            newestGamesCollectionView.games.value = newestGames
            newestGamesCollectionView.collectionView.reloadData()
        }
    }

    var mostPopularGames: [Game] = [] {
        didSet {
            mostPopularGamesCollectionView.games.value = mostPopularGames
            mostPopularGamesCollectionView.collectionView.reloadData()
        }
    }

    var allGames: [Game] = [] {
        didSet {
            allGamesCV.games.value = allGames
            allGamesCV.collectionView.reloadData()

            let calculatedHeight = 200
                + 200
                + self.allGamesCV.calculatedHeight

            stackView.snp.updateConstraints ({
                $0.height.equalTo( calculatedHeight )
            })

            scrollView.layoutSubviews()
            stackView.updateConstraints()
            allGamesCV.collectionView.layoutIfNeeded()
        }
    }

    let horizontalFlowLayout = UICollectionView.collectionViewLayout
    let verticalFlowLayout = UICollectionView.verticalCollectionViewLayout

    var delegate: GameListViewDelegate? = nil
    private let stackView: UIView
    private let scrollView: UIScrollView

    let bag = DisposeBag()
    let newestGamesCollectionView: GameListItem = GameListItem(title: Language.newestGames.localized())
    let mostPopularGamesCollectionView: GameListItem = GameListItem(title: Language.popularGames.localized())
    let allGamesCV = GameListItem(title: Language.allGames.localized(), direction: .vertical)

    override init(frame: CGRect) {
        self.stackView = UIView(frame: .zero)
        self.scrollView = UIScrollView(frame: CGRect.zero)
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI() {
        insertScrollView()
        insertNewestGamesCollectionView()
        insertMostPopularGamesCollectionView()
        insertAllGamesCollectionView()
        backgroundColor = .white
    }

    func insertScrollView() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }

        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(600)
            $0.width.equalToSuperview()
        }
    }

    func insertNewestGamesCollectionView() {
        stackView.addSubview(newestGamesCollectionView)
        newestGamesCollectionView.snp.makeConstraints({
            $0.top.right.left.equalToSuperview()
            $0.height.equalTo(200)
        })
        newestGamesCollectionView.delegate = self
    }

    func insertMostPopularGamesCollectionView() {
        stackView.addSubview(mostPopularGamesCollectionView)
        mostPopularGamesCollectionView.snp.makeConstraints({
            $0.top.equalTo(newestGamesCollectionView.snp.bottom)
            $0.right.left.equalToSuperview()
            $0.height.equalTo(200)
        })

        mostPopularGamesCollectionView.borderColor = GCStyleKit.gray234
        mostPopularGamesCollectionView.delegate = self
    }

    func insertAllGamesCollectionView() {
        stackView.addSubview(allGamesCV)
        allGamesCV.snp.makeConstraints {
            $0.top.equalTo(mostPopularGamesCollectionView.snp.bottom).offset(20)
            $0.right.left.bottom.equalToSuperview()
        }
        allGamesCV.delegate = self
    }
}

extension GamesListView: GameListItemDelegate {
    func didSelectGame(game: Game) {
        self.delegate?.didSelectGame(game: game)
    }
}
