import UIKit
import RxCocoa
import RxSwift
import SnapKit

class GamesListView: UIView {

    let data: Variable<[String]> = Variable([])

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let cellWidth = (UIScreen.main.bounds.width/4) - 4
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 0, right: 3)
        layout.minimumInteritemSpacing = 2;
        layout.minimumLineSpacing = 2;
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.scrollDirection = .horizontal
        return layout
    }()

    private let disposeBag = DisposeBag()
    var gridCollectionView: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI() {
        insertCollectionView()
        backgroundColor = .white
    }

    func insertCollectionView() {

        let cellFrame = CGRect(x: 0,
                               y: 0,
                               width: collectionViewLayout.itemSize.width,
                               height: collectionViewLayout.itemSize.height)


        gridCollectionView = UICollectionView(frame: cellFrame,
                                              collectionViewLayout: collectionViewLayout)

        gridCollectionView.backgroundColor = .white
        gridCollectionView.register(GridCollectionViewCell.self,
                                    forCellWithReuseIdentifier: GridCollectionViewCell.idenfifier)
        gridCollectionView.showsHorizontalScrollIndicator = false
        addSubview(gridCollectionView)

        //Layout
        gridCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        //Rx
        data.asObservable()
            .bind(to: gridCollectionView.rx.items(cellIdentifier: GridCollectionViewCell.idenfifier,
                                                  cellType: GridCollectionViewCell.self)) { index, model, cell in
                                                    cell.configureUI()
                                                    cell.value.value = model
            }
            .disposed(by: disposeBag)
    }
}
