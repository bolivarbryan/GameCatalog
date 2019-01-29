import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class GameDetailsViewController: UIViewController {
    
    let game: Game
    
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
        let gradientView = UIView(frame: .zero)
        view.addSubview(gradientView)
        
        gradientView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            $0.height.equalTo(340)
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 340)
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        gradientView.layer.addSublayer(gradientLayer)
        
        let textView = UITextView(frame: .zero)
        view.addSubview(textView)
        
        textView.snp.makeConstraints {
            $0.top.equalTo(gradientView.snp.bottom).offset(28)
            $0.left.bottom.equalToSuperview()
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
        
    }
}
