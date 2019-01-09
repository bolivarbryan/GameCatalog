import UIKit

class GCLabel: UILabel {

    enum FontSize: CGFloat {
        case small = 12.0
        case medium = 14.0
        case large = 24.0
    }

    enum FontWeight: String {
        case regular = ""
        case bold = "-Bold"
    }

    enum FontFamily: String {
        case system = "Helvetica"

        func getFontName(weight: FontWeight) -> String {
            return "\(self.rawValue)\(weight.rawValue)"
        }
    }

    init(text: String,
         color: UIColor, size: FontSize = .small,
         weight: FontWeight = .regular,
         family: FontFamily = .system) {

        super.init(frame: CGRect.zero)
        self.text = text
        textColor = color
        self.font = UIFont(name: family.getFontName(weight: weight), size: size.rawValue)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
