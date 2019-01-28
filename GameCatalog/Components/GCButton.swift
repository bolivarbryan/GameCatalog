import UIKit

class GCButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        backgroundColor = GCStyleKit.fuschia
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        snp.makeConstraints({
            $0.height.equalTo(44)
        })
        layer.cornerRadius = 4
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
