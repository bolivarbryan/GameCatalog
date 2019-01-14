import UIKit
import RxSwift
import RxCocoa

class CategoryCollectionViewCell: UICollectionViewCell {
    static let idenfifier = "UICollectionViewCellIdentifier"
    private let bag = DisposeBag()
    var value: Variable<String?> = Variable(nil)
    private let label: GCLabel

    override var isSelected: Bool {
        didSet {
            if isSelected == true {
                backgroundColor  = GCStyleKit.fuschia
                label.textColor = .white
            } else {
                backgroundColor  = .white
                label.textColor = GCStyleKit.fuschia
            }
        }
    }

    override init(frame: CGRect) {
        label = GCLabel(text: "",
                        color: GCStyleKit.fuschia,
                        size: .medium,
                        weight: .regular,
                        family: .system)

        super.init(frame: frame)
        configureUI()
    }

    func configureUI(){
        addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        value.asObservable()
            .bind(to: label.rx.text)
            .disposed(by: bag)

        label.textAlignment = .center
        clipsToBounds = true
        layer.cornerRadius = 5
        layer.borderColor = GCStyleKit.fuschia.cgColor
        layer.borderWidth = 1
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
