import UIKit

fileprivate let rightMargin: CGFloat = -26
fileprivate let leftMargin: CGFloat = 21
fileprivate let statusBarHeight: CGFloat = 20
fileprivate let barHeight: CGFloat = 99

class HeaderView: UIView {
    let rightButton: UIButton
    private let titleLabel: GCLabel

    enum NavigationAction {
        case filter

        var image: UIImage {
            switch self {
            case .filter:
                return #imageLiteral(resourceName: "navigationFilter")
            }
        }
    }

    init(title: Language, rightAction: NavigationAction) {
        self.rightButton = UIButton(frame: CGRect.zero)

        self.titleLabel = GCLabel(text: title.localized(),
                                  color: .black,
                                  size: .large,
                                  weight: .regular,
                                  family: .system)

        super.init(frame: CGRect.zero)
        self.rightButton.setImage(rightAction.image, for: .normal)
        self.titleLabel.text = title.localized()
        configureUI()
        setupNavigationActions(rightAction: rightAction)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        addSubview(titleLabel)
        addSubview(rightButton)

        rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(statusBarHeight)
            $0.right.equalToSuperview().offset(rightMargin)
        }

        snp.makeConstraints{
            $0.height.equalTo(barHeight)
        }

        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(leftMargin)
            $0.centerY.equalToSuperview().offset(statusBarHeight)
        }
    }

    private func setupNavigationActions(rightAction: NavigationAction) {
        switch rightAction {
        case .filter:
            print("x")
        }
    }
}
