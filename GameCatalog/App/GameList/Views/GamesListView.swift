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


    var newestGamesCollectionView: GameListItem!
    var mostPopularGamesCollectionView: GameListItem!
    var allGamesCollectionView: UICollectionView!

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
        newestGamesCollectionView = GameListItem(title: "Newest Games")
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

        mostPopularGamesCollectionView = GameListItem(title: "Popular")
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
        let allGamesCV = GameListItem(title: "All", direction: .vertical)
        stackView.addSubview(allGamesCV)
        allGamesCV.snp.makeConstraints {
            $0.top.equalTo(mostPopularGamesCollectionView.snp.bottom).offset(20)
            $0.right.left.bottom.equalToSuperview()
        }

        allGames.asObservable()
            .subscribe(onNext: { [weak self] _ in

                guard let self = self else { return }

                self.stackView.snp.updateConstraints ({
                    $0.height.equalTo( (CGFloat(self.allGames.value.count)/1.75 * self.verticalFlowLayout.itemSize.height) + 300 )
                })

                self.scrollView.layoutSubviews()
                self.stackView.updateConstraints()
                allGamesCV.collectionView.layoutIfNeeded()
            })
            .disposed(by: disposeBag)

        allGames.asObservable()
            .bind(to: allGamesCV.games)
            .disposed(by: disposeBag)

    }
}
