import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class GameDetailsViewController: UIViewController {
    
    let game: Game
    let disposeBag = DisposeBag()
    
    init(game: Game) {
        self.game = game
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    func configureUI() {
        view.backgroundColor = .white
        let gradientView = UIImageView(image: #imageLiteral(resourceName: "bg"))
        view.addSubview(gradientView)
        
        gradientView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            $0.height.equalTo(340)
        }
        
        let textView = UITextView(frame: .zero)
        view.addSubview(textView)
        
        textView.snp.makeConstraints {
            $0.top.equalTo(gradientView.snp.bottom).offset(28)
            $0.left.bottom.equalToSuperview().offset(28)
            $0.right.equalToSuperview().offset(-28)
            $0.bottom.equalToSuperview()
        }
        
        textView.text = game.description
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .darkGray
        
        let iconView = UIImageView(frame: .zero)
        view.addSubview(iconView)
        iconView.kf.setImage(with: game.imageSource)
        iconView.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.bottom.equalTo(gradientView)
            $0.width.equalToSuperview().multipliedBy(0.4)
            $0.height.equalToSuperview().multipliedBy(0.2)
        }
        
        iconView.contentMode = .scaleAspectFit
        let backButton = UIButton(frame: .zero)
        view.addSubview(backButton)
        backButton.setImage(#imageLiteral(resourceName: "back_Icon"), for: .normal)
        backButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(19)
            $0.height.width.equalTo(30)
            $0.top.equalTo(40)
        }
        
        backButton.rx.tap.asObservable()
            .subscribe(onNext:{ _ in
                self.navigationController?.popViewController(animated: true)
            })
        .disposed(by: disposeBag)
        
        let skuLabel = GCLabel(text: "SKU: \(game.sku)",
                               color: .init(white: 1, alpha: 0.17),
                               size: .medium,
                               weight: .bold,
                               family: .system)
        view.addSubview(skuLabel)
        skuLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(93)
            $0.left.equalToSuperview().offset(29)
        }
        
        let nameLabel = GCLabel(text: game.name.uppercased(),
            color: .white,
            size: .large,
            weight: .bold,
            family: .system)
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(skuLabel.snp.bottom)
            $0.left.equalToSuperview().offset(29)
        }
        
        let universeLabel = GCLabel(text: game.universe.uppercased(),
                                color: .init(white: 1, alpha: 0.5),
                                size: .section,
                                weight: .bold,
                                family: .system)
        
        view.addSubview(universeLabel)
        universeLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.left.equalToSuperview().offset(29)
        }
        
        let kindLabel = GCLabel(text: " • \(game.kind.uppercased())",
                                    color: .white,
                                    size: .section,
                                    weight: .bold,
                                    family: .system)
        
        view.addSubview(kindLabel)
        kindLabel.snp.makeConstraints {
            $0.bottom.equalTo(universeLabel.snp.bottom)
            $0.left.equalTo(universeLabel.snp.right)
        }
        
        let numberFormat = NumberFormatter()
        numberFormat.usesGroupingSeparator = true;
        numberFormat.groupingSeparator = ",";
        numberFormat.groupingSize = 3;
        
        let downloads = NSNumber(value: game.downloadsValue)
        let value = numberFormat.string(from: downloads)!
        
        let downloadsLabel = GCLabel(text: "\(value) downloads",
                                    color: .init(white: 1, alpha: 0.5),
                                    size: .section,
                                    weight: .regular,
                                    family: .system)
        
        view.addSubview(downloadsLabel)
        downloadsLabel.snp.makeConstraints {
            $0.top.equalTo(kindLabel.snp.bottom).offset(22)
            $0.left.equalToSuperview().offset(29)
        }
        
        let starImage = #imageLiteral(resourceName: "star-on")
        let starImageOff = #imageLiteral(resourceName: "star-off")
        
        let starsContainer = UIView(frame: .zero)
        view.addSubview(starsContainer)
        starsContainer.snp.makeConstraints {
            $0.top.equalTo(downloadsLabel.snp.bottom).offset(5)
            $0.left.equalTo(29)
        }
        
        let offset = 22
        for i in (0...4) {
            let image = i <= game.rateValue ? starImage : starImageOff
            let starImageView = UIImageView(image: image)
            starsContainer.addSubview(starImageView)
            starImageView.snp.makeConstraints {
                $0.left.equalToSuperview().offset(offset * i)
                $0.top.equalToSuperview()
                $0.height.width.equalTo(16.5)
            }
        }
        
        let priceContainer = UIView(frame: .zero)
        view.addSubview(priceContainer)
        priceContainer.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.left.equalToSuperview().offset(29)
            $0.top.equalTo(starsContainer.snp.bottom).offset(50)
        }
        priceContainer.layer.cornerRadius = 6.86
        priceContainer.backgroundColor = .white
        
        let priceLabel = GCLabel(text: game.formattedPrice,
                                 color: GCStyleKit.redSunset,
                                 size: .section,
                                 weight: .bold,
                                 family: .system)
        
        priceContainer.addSubview(priceLabel)
        priceLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
    }
    
}
