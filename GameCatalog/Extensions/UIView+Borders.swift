import UIKit

extension UIView {
    func applyCorneredBorder(color: UIColor = GCStyleKit.fuschia, cornerRadius: CGFloat = 5) {
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = 1
        self.clipsToBounds = true
    }
}
