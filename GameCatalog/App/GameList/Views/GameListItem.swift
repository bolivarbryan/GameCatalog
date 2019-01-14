import UIKit
import RxCocoa
import RxSwift

class GameListItem: UIView {
    let titleLabel: GCLabel
    var collectionView: UICollectionView!
    let games: Variable<[Game]> = Variable([])
    private let disposeBag = DisposeBag()

    let horizontalFlowLayout = UICollectionView.collectionViewLayout
    let verticalFlowLayout = UICollectionView.verticalCollectionViewLayout
    var borderColor: UIColor = GCStyleKit.fuschia {
        didSet {
            collectionView.reloadData()
        }
    }

    init(title: String) {

        self.titleLabel = GCLabel(text: title,
                                  color: GCStyleKit.gray102,
                                  size: .section,
                                  weight: .bold,
                                  family: .system)

        super.init(frame: .zero)
        configureHorizontalUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureHorizontalUI() {
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints({
            $0.top.left.equalToSuperview().offset(27)
            $0.width.equalToSuperview()
            $0.height.equalTo(30)
        })


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
            $0.top.equalTo(titleLabel.snp.bottom)
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
}
