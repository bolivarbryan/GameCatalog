import UIKit

extension UITableViewCell {
    func addSeparator() {
        let line = UIView(frame: .zero)
        addSubview(line)
        line.backgroundColor = UIColor.groupTableViewBackground
        line.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.right.bottom.left.equalToSuperview()
        }
    }
}
