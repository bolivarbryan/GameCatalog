import UIKit
import RxCocoa
import RxSwift

fileprivate let height: CGFloat = 40

class CategoriesListView: UIView {

    //MARK: Properties
    let categories: Variable<[String]> = Variable([])
    let bag = DisposeBag()

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let cellWidth = (UIScreen.main.bounds.width/3.5) - 3
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 27, bottom: 0, right: 3)
        layout.minimumInteritemSpacing = 2;
        layout.minimumLineSpacing = 10;
        layout.itemSize = CGSize(width: cellWidth, height: height)
        layout.scrollDirection = .horizontal
        return layout
    }()

    var collectionView: UICollectionView! {
        didSet {
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.backgroundColor = .white
        }
    }

    //MARK: Initializer

    init(datasource: [String]) {
        super.init(frame: .zero)
        categories.value = datasource

        snp.makeConstraints {
            $0.height.equalTo(height)
        }

        configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Functions

    func configureUI() {
        configureCollectionView()
    }

    private func configureCollectionView() {
        let cellFrame = CGRect(x: 0,
                               y: 0,
                               width: collectionViewLayout.itemSize.width,
                               height: collectionViewLayout.itemSize.height)

        collectionView = UICollectionView(frame: cellFrame,
                                          collectionViewLayout: collectionViewLayout)

        collectionView.register(CategoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: CategoryCollectionViewCell.idenfifier)

        addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        //Rx
        categories.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: CategoryCollectionViewCell.idenfifier,
                                              cellType: CategoryCollectionViewCell.self)) {  row, element, cell in
                                                cell.value.value = element
            }
            .disposed(by: bag)

        //Rx Did Select and Deselect
        collectionView.rx.modelSelected(String.self)
            .subscribe(onNext:{ _ in

            })
            .disposed(by: bag)

        collectionView.rx.itemSelected
            .subscribe(onNext:{
                print($0)
            })
            .disposed(by: bag)

    }

}
