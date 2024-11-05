import UIKit

protocol ShadowCasting: UIView {
    
    func addDropShadow(
        withOffset offset: CGFloat,
        opacity: Float,
        radius: CGFloat
    )
}


//  MARK: - Default Implementation

extension ShadowCasting {
   
    func addDropShadow(
        withOffset offset: CGFloat = 2.5,
        opacity: Float = 0.2,
        radius: CGFloat = 18
    ) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: 0, height: offset)
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
