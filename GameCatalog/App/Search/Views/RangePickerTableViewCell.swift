import UIKit
import RangeSeekSlider

protocol RangePickerTableViewCellDelegate {
    func didSelectRange(range: (Double, Double))
}

class RangePickerTableViewCell: UITableViewCell {

    static let identifier = "RangePickerTableViewCell"
    let slider = RangeSeekSlider(frame: .zero)
    var delegate: RangePickerTableViewCellDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureUI() {

        if subviews.contains(slider) {
            return
        }

        selectionStyle = .none
        slider.minValue = 19.99
        slider.maxValue = 199.99
        slider.selectedMaxValue = slider.maxValue
        slider.lineHeight = 4
        slider.colorBetweenHandles = GCStyleKit.green
        slider.tintColor = .lightGray
        slider.minLabelColor = .black
        slider.maxLabelColor = .black
        slider.handleImage = #imageLiteral(resourceName: "handleIcon")
        slider.labelsFixed = true
        slider.numberFormatter.numberStyle = .currency
        slider.numberFormatter.currencyDecimalSeparator = ","
        slider.numberFormatter.allowsFloats = true
        slider.numberFormatter.decimalSeparator = ","
        slider.labelPadding = 15
        slider.minLabelFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        slider.maxLabelFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        slider.minDistance = 20
        slider.delegate = self
        addSubview(slider)
        slider.snp.makeConstraints( {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(10)
        })
    }

}

extension RangePickerTableViewCell: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        delegate?.didSelectRange(range: (Double(minValue), Double(maxValue)))
    }
}
