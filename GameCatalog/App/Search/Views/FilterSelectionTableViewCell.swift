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
    }

    enum ContentStyle {
        case rate
        case text
    }

    static let identifier = "FilterSelectionTableViewCell"
    var value: String = ""
    var checkmarkStyle: CheckMarkStyle = .circled
    var contentStyle: ContentStyle = .text

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureUI() {
        switch contentStyle {
        case .text:
            textLabel?.text = value
        case .rate:
            guard
                let starsCount = Int(value)
                else { return }

            addStars(value: starsCount)
        }
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
