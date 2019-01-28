import UIKit

class FilterSelectionTableViewCell: UITableViewCell {

    enum CheckMarkStyle {
        case squared
        case circled

        var onImage: UIImage {
            switch self {
            case .circled:
                return #imageLiteral(resourceName: "roundCheck-on")
            case .squared:
                return #imageLiteral(resourceName: "squaredCheck-on")
            }
        }

        var offImage: UIImage {
            switch self {
            case .circled:
                return #imageLiteral(resourceName: "roundCheck")
            case .squared:
                return #imageLiteral(resourceName: "squaredCheck")
            }
        }

        var checkmarkButton: UIButton {
            let button = UIButton(frame: .zero)
            button.setImage(self.onImage, for: .highlighted)
            button.setImage(self.onImage, for: .selected)
            button.setImage(self.offImage, for: .normal)
            return button
        }
    }

    enum ContentStyle {
        case rate
        case text
    }

    static let identifier = "FilterSelectionTableViewCell"
    var value: String = ""
    var checkmarkStyle: CheckMarkStyle = .circled
    var contentStyle: ContentStyle = .text
    var checkButton: UIButton? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkButton?.isSelected = selected
    }

    func configureUI() {
        selectionStyle = .none
        switch contentStyle {
        case .text:
            textLabel?.text = value
        case .rate:
            guard
                let starsCount = Int(value)
                else { return }

            addStars(value: starsCount)
        }

        checkButton =  checkmarkStyle.checkmarkButton
        guard
            let checkButton = checkButton
            else { return }

        addSubview(checkButton)
        checkButton.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-11)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(17)
        })
        addSeparator()
    }

    func addStars(value: Int) {

        let offset = 21

        for i in (1...(6 - value)) {
            let starImage = #imageLiteral(resourceName: "star")
            let starImageView = UIImageView(image: starImage)
            addSubview(starImageView)
            starImageView.snp.makeConstraints {
                $0.left.equalToSuperview().offset(offset * i)
                $0.centerY.equalToSuperview()
                $0.height.width.equalTo(16.5)
            }
        }
    }
}
