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

        mostPopularGamesCollectionView = GameListItem(title: "Most Popular Games")
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
        let titleLabel = GCLabel(text: "All",
                                 color: GCStyleKit.gray102,
                                 size: .section,
                                 weight: .bold,
                                 family: .system)

        stackView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints({
            $0.top.equalTo(mostPopularGamesCollectionView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(27)
            $0.width.equalToSuperview()
            $0.height.equalTo(30)
        })

        let cellFrame = CGRect(x: 0,
                               y: 0,
                               width: verticalFlowLayout.itemSize.width,
                               height: verticalFlowLayout.itemSize.height)

        allGamesCollectionView = UICollectionView(frame: cellFrame,
                                                          collectionViewLayout: verticalFlowLayout)

        allGamesCollectionView.backgroundColor = .white
        allGamesCollectionView.showsHorizontalScrollIndicator = false
        allGamesCollectionView.register(GameCollectionViewCell.self,
                                                forCellWithReuseIdentifier: GameCollectionViewCell.idenfifier)
        allGamesCollectionView.isScrollEnabled = false

        stackView.addSubview(allGamesCollectionView)
        allGamesCollectionView.snp.makeConstraints({
            $0.right.left.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
        })

        //Rx
        allGames.asObservable()
            .bind(to: allGamesCollectionView.rx.items(cellIdentifier: GameCollectionViewCell.idenfifier,
                                                              cellType: GameCollectionViewCell.self)) { index, model, cell in
                                                                cell.game.value = model
                                                                cell.pictureContainerView.applyCorneredBorder(color: GCStyleKit.gray234, cornerRadius: 5)
            }
            .disposed(by: disposeBag)

        allGames.asObservable()
            .subscribe(onNext: { [weak self] _ in

                guard let self = self else { return }

                self.stackView.snp.updateConstraints ({
                    $0.height.equalTo( (CGFloat(self.allGames.value.count)/1.75 * self.verticalFlowLayout.itemSize.height) + 300 )
                })

                self.scrollView.layoutSubviews()
                self.stackView.updateConstraints()
                self.allGamesCollectionView.layoutIfNeeded()
            })
            .disposed(by: disposeBag)


    }
}
