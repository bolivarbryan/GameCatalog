import UIKit
import RxCocoa
import RxSwift
import SnapKit

protocol GameListViewDelegate {
    func didSelectGame(game: Game)
}

class GamesListView: UIView {
    let newestGames: Variable<[Game]> = Variable([])
    let mostPopularGames: Variable<[Game]> = Variable([])
    let allGames: Variable<[Game]> = Variable([])

    let horizontalFlowLayout = UICollectionView.collectionViewLayout
    let verticalFlowLayout = UICollectionView.verticalCollectionViewLayout

    var delegate: GameListViewDelegate? = nil
    private let stackView: UIView
    private let scrollView: UIScrollView

    let newestGamesCollectionView: GameListItem = GameListItem(title: Language.newestGames.localized())
    let mostPopularGamesCollectionView: GameListItem = GameListItem(title: Language.popularGames.localized())
    let allGamesCV = GameListItem(title: Language.allGames.localized(), direction: .vertical)

    private let disposeBag = DisposeBag()

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

        newestGames.asObservable()
            .bind(to: newestGamesCollectionView.games)
            .disposed(by: disposeBag)
    }

    func insertMostPopularGamesCollectionView() {
        stackView.addSubview(mostPopularGamesCollectionView)
        mostPopularGamesCollectionView.snp.makeConstraints({
            $0.top.equalTo(newestGamesCollectionView.snp.bottom)
            $0.right.left.equalToSuperview()
            $0.height.equalTo(200)
        })

        //Rx
        mostPopularGames.asObservable()
            .bind(to: mostPopularGamesCollectionView.games)
            .disposed(by: disposeBag)

        mostPopularGamesCollectionView.borderColor = GCStyleKit.gray234
    }

    func insertAllGamesCollectionView() {
        stackView.addSubview(allGamesCV)
        allGamesCV.snp.makeConstraints {
            $0.top.equalTo(mostPopularGamesCollectionView.snp.bottom).offset(20)
            $0.right.left.bottom.equalToSuperview()
        }

        allGames.asObservable()
            .subscribe(onNext: { [weak self] _ in

                guard let self = self else { return }

                let calculatedHeight = 200
                    + 200
                    + self.allGamesCV.calculatedHeight

                self.stackView.snp.updateConstraints ({

                    $0.height.equalTo( calculatedHeight )
                })

                self.scrollView.layoutSubviews()
                self.stackView.updateConstraints()
                self.allGamesCV.collectionView.layoutIfNeeded()
            })
            .disposed(by: disposeBag)

        allGames.asObservable()
            .bind(to: allGamesCV.games)
            .disposed(by: disposeBag)

    }
}
