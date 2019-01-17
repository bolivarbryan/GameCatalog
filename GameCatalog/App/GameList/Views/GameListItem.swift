import UIKit
import RxCocoa
import RxSwift

class GameListItem: UIView {
    let titleLabel: GCLabel
    var collectionView: UICollectionView!
    let games: Variable<[Game]> = Variable([])
    private let disposeBag = DisposeBag()
    var title: String

    enum Direction {
        case horizontal
        case vertical
    }

    var direction: Direction

    var calculatedHeight: CGFloat {
        switch direction {
        case .horizontal:
            return self.bounds.height
        case .vertical:
            return titleLabel.bounds.height + collectionView.contentSize.height + 65
        }
    }


    let horizontalFlowLayout = UICollectionView.collectionViewLayout
    let verticalFlowLayout = UICollectionView.verticalCollectionViewLayout
    var borderColor: UIColor = GCStyleKit.fuschia {
        didSet {
            collectionView.reloadData()
        }
    }

    init(title: String, direction: Direction = .horizontal) {
        self.title = title
        self.titleLabel = GCLabel(text: title,
                                  color: GCStyleKit.gray102,
                                  size: .section,
                                  weight: .bold,
                                  family: .system)
        self.direction = direction
        super.init(frame: .zero)

        insertHeader()


        switch direction {
        case .horizontal:
            configureHorizontalUI()
        case .vertical:
            configureVerticalUI()
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func insertHeader() {
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints({
            $0.top.left.equalToSuperview().offset(27)
            $0.height.equalTo(30)
        })

        let lineView = UIView(frame: .zero)
        addSubview(lineView)
        lineView.snp.makeConstraints({
            $0.left.equalTo(titleLabel.snp.right).offset(41)
            $0.centerY.equalTo(titleLabel)
            $0.right.equalToSuperview()
            $0.height.equalTo(1)
        })
        lineView.backgroundColor = GCStyleKit.gray151

        games.asObservable()
            .map { "\(self.title) (\($0.count))" }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
    }

    func configureHorizontalUI() {
        let cellFrame = CGRect(x: 0,
                               y: 0,
                               width: horizontalFlowLayout.itemSize.width,
                               height: horizontalFlowLayout.itemSize.height)

        collectionView = UICollectionView(frame: cellFrame,
                                          collectionViewLayout: horizontalFlowLayout)

        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(GameCollectionViewCell.self,
                                forCellWithReuseIdentifier: GameCollectionViewCell.idenfifier)

        addSubview(collectionView)
        collectionView.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.right.left.equalToSuperview()
            $0.height.equalTo(150)
        })

        games.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: GameCollectionViewCell.idenfifier,
                                              cellType: GameCollectionViewCell.self)) { index, model, cell in
                                                cell.game.value = model
                                                cell.pictureContainerView.applyCorneredBorder(color: self.borderColor,
                                                                                              cornerRadius: 5)
            }
            .disposed(by: disposeBag)

    }

    func configureVerticalUI() {

        let cellFrame = CGRect(x: 0,
                               y: 0,
                               width: UICollectionView.verticalCollectionViewLayout.itemSize.width,
                               height: UICollectionView.verticalCollectionViewLayout.itemSize.height)

        collectionView = UICollectionView(frame: cellFrame,
                                          collectionViewLayout: UICollectionView.verticalCollectionViewLayout)

        collectionView.register(GameCollectionViewCell.self,
                                forCellWithReuseIdentifier: GameCollectionViewCell.idenfifier)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white

        self.games.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: GameCollectionViewCell.idenfifier,
                                              cellType: GameCollectionViewCell.self)) { index, model, cell in
                                                cell.game.value = model
                                                cell.pictureContainerView.applyCorneredBorder(color: GCStyleKit.gray234, cornerRadius: 5)
            }
            .disposed(by: disposeBag)

        addSubview(collectionView)
        collectionView.snp.makeConstraints({
            $0.right.left.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
        })
    }
}
