import UIKit
import RxSwift
import RxCocoa
import Kingfisher

private let leftMargin: CGFloat = 11
private let rightMargin: CGFloat = -11
private let verticalMargin: CGFloat = 5

class GameCollectionViewCell: UICollectionViewCell {
    static let idenfifier = "UICollectionViewCellIdentifier"
    private let bag = DisposeBag()
    var game: Variable<Game?> = Variable(nil)

    //MARK: - Properties
    let pictureContainerView: UIView = UIView(frame: .zero)

    private var picture: UIImageView {
        didSet {
            picture.contentMode = .scaleAspectFit
        }
    }
    
    private let nameLabel: GCLabel
    private let categoryLabel: GCLabel

    override init(frame: CGRect) {
        self.picture = UIImageView(frame: .zero)
        self.nameLabel = GCLabel.init(text: "", color: .black)
        self.categoryLabel = GCLabel.init(text: "", color: .black)
        super.init(frame: frame)
        configureUI()
        bindToModelToComponents()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        addSubview(pictureContainerView)
        pictureContainerView.addSubview(picture)
        addSubview(nameLabel)
        addSubview(categoryLabel)

        pictureContainerView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            $0.height.equalTo(self.snp.width)
        }

        picture.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(leftMargin)
            $0.bottom.right.equalToSuperview().offset(rightMargin)
        }

        pictureContainerView.backgroundColor = GCStyleKit.gray251
        pictureContainerView.applyCorneredBorder(color: GCStyleKit.fuschia, cornerRadius: 5)

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(picture.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(leftMargin)
            $0.right.equalToSuperview().offset(rightMargin)
        }

        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(verticalMargin)
            $0.left.equalToSuperview().offset(leftMargin)
            $0.rightMargin.equalToSuperview().offset(rightMargin)
        }

        nameLabel.textAlignment = .center
        categoryLabel.textAlignment = .center
    }

    private func bindToModelToComponents() {
        game.asObservable()
            .map({ $0?.imageSource })
            .subscribe(onNext: {
                self.picture.kf.setImage(with: $0)
            })
            .disposed(by: bag)

        game.asObservable()
            .map ({ $0?.name })
            .bind(to: nameLabel.rx.text)
            .disposed(by: bag)

        game.asObservable()
            .map ({ $0?.universe })
            .bind(to: categoryLabel.rx.text)
            .disposed(by: bag)
    }

}
