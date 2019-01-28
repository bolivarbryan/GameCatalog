import UIKit
import SnapKit
import RxSwift

protocol GameListViewDelegate {
    func didSelectGame(game: Game)
}

class GamesListView: UIView {
    var newestGames: [Game] = [] {
        didSet {
            if newestGames.count == 0 {
                newestGamesCollectionView.snp.updateConstraints {
                    $0.height.equalTo(0)
                }
            } else {
                newestGamesCollectionView.snp.updateConstraints {
                    $0.height.equalTo(240)
                }
            }
            newestGamesCollectionView.games.value = newestGames
            newestGamesCollectionView.collectionView.reloadData()
        }
    }

    var mostPopularGames: [Game] = [] {
        didSet {
            if mostPopularGames.count == 0 {
                mostPopularGamesCollectionView.snp.updateConstraints {
                    $0.height.equalTo(0)
                }
            } else {
                mostPopularGamesCollectionView.snp.updateConstraints {
                    $0.height.equalTo(240)
                }
            }
            mostPopularGamesCollectionView.games.value = mostPopularGames
            mostPopularGamesCollectionView.collectionView.reloadData()
        }
    }

    var allGames: [Game] = [] {
        didSet {
            allGamesCV.games.value = allGames
            allGamesCV.collectionView.reloadData()

            var mostPopularSectionHeight: CGFloat = 0
            var newestGamesSectionHeight: CGFloat = 0

            if mostPopularGames.count > 0 {
                mostPopularSectionHeight = 240
            }

            if newestGames.count > 0 {
                newestGamesSectionHeight = 240
            }

            let calculatedHeight = mostPopularSectionHeight
                + newestGamesSectionHeight
                + self.allGamesCV.calculatedHeight

            containerView.snp.updateConstraints ({
                $0.height.equalTo( calculatedHeight )
            })

            scrollView.layoutSubviews()
            containerView.updateConstraints()
            allGamesCV.collectionView.layoutIfNeeded()
        }
    }

    var delegate: GameListViewDelegate? = nil
    private let containerView: UIView
    private let scrollView: UIScrollView

    let bag = DisposeBag()
    let newestGamesCollectionView: GameListItem = GameListItem(title: Language.newestGames.localized())
    let mostPopularGamesCollectionView: GameListItem = GameListItem(title: Language.popularGames.localized())
    let allGamesCV = GameListItem(title: Language.allGames.localized(), direction: .vertical)

    override init(frame: CGRect) {
        self.containerView = UIView(frame: .zero)
        self.scrollView = UIScrollView(frame: CGRect.zero)
        super.init(frame: .zero)
        self.clipsToBounds = true
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

        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(600)
            $0.width.equalToSuperview()
        }
    }

    func insertNewestGamesCollectionView() {
        containerView.addSubview(newestGamesCollectionView)
        newestGamesCollectionView.snp.makeConstraints({
            $0.top.right.left.equalToSuperview()
            $0.height.equalTo(200)
        })
        newestGamesCollectionView.delegate = self
    }

    func insertMostPopularGamesCollectionView() {
        containerView.addSubview(mostPopularGamesCollectionView)
        mostPopularGamesCollectionView.snp.makeConstraints({
            $0.top.equalTo(newestGamesCollectionView.snp.bottom)
            $0.right.left.equalToSuperview()
            $0.height.equalTo(200)
        })

        mostPopularGamesCollectionView.borderColor = GCStyleKit.gray234
        mostPopularGamesCollectionView.delegate = self
    }

    func insertAllGamesCollectionView() {
        containerView.addSubview(allGamesCV)
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
