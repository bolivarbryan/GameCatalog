import UIKit

public class GCStyleKit : NSObject {

    //// Cache

    private struct Cache {
        static let fuschia: UIColor = UIColor(red: 0.859, green: 0.188, blue: 0.412, alpha: 1.000)
        static let gray102: UIColor = UIColor(red: 0.400, green: 0.400, blue: 0.400, alpha: 1.000)
        static let redSunset: UIColor = UIColor(red: 0.898, green: 0.322, blue: 0.286, alpha: 1.000)
        static let blueSunset: UIColor = UIColor(red: 0.165, green: 0.322, blue: 0.745, alpha: 1.000)
        static let yellow: UIColor = UIColor(red: 0.976, green: 0.624, blue: 0.000, alpha: 1.000)
        static let yellowPinkColor: UIColor = UIColor(red: 0.504, green: 0.278, blue: 0.757, alpha: 1.000)
        static let gray251: UIColor = UIColor(red: 0.984, green: 0.984, blue: 0.984, alpha: 1.000)
        static let gray234: UIColor = UIColor(red: 0.918, green: 0.918, blue: 0.918, alpha: 1.000)
        static let gray151: UIColor = UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1.000)
        static let green: UIColor = UIColor(red: 0.392, green: 0.764, blue: 0.157, alpha: 1.000)

        static let yellowPink: CGGradient = CGGradient(colorsSpace: nil, colors: [GCStyleKit.yellow.cgColor, GCStyleKit.fuschia.cgColor] as CFArray, locations: [0, 1])!
    }

    //// Colors

    @objc dynamic public class var fuschia: UIColor { return Cache.fuschia }
    @objc dynamic public class var gray102: UIColor { return Cache.gray102 }
    @objc dynamic public class var redSunset: UIColor { return Cache.redSunset }
    @objc dynamic public class var blueSunset: UIColor { return Cache.blueSunset }
    @objc dynamic public class var yellow: UIColor { return Cache.yellow }
    @objc dynamic public class var yellowPinkColor: UIColor { return Cache.yellowPinkColor }
    @objc dynamic public class var gray251: UIColor { return Cache.gray251 }
    @objc dynamic public class var gray234: UIColor { return Cache.gray234 }
    @objc dynamic public class var gray151: UIColor { return Cache.gray151 }
    @objc dynamic public class var green: UIColor { return Cache.green }

    //// Gradients

    @objc dynamic public class var yellowPink: CGGradient { return Cache.yellowPink }

    //// Drawing Methods

    @objc dynamic public class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 240, height: 120), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 240, height: 120), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 240, y: resizedFrame.height / 120)
        
        context.restoreGState()

    }




    @objc(GCStyleKitResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
