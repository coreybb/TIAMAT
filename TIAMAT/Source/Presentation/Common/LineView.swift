import UIKit

class LineView: UIView {
    
    enum Orientation {
        case horizontal, vertical
    }
    
    //  MARK: - Public Properties
    
    let orientation: Orientation
    let thickness: CGFloat
    
    
    //  MARK: - Initialization
    
    init(
        orientation: Orientation,
        color: UIColor = .lightGray,
        thickness: CGFloat = 1.0 / UIScreen.main.scale
    ) {
        self.orientation = orientation
        self.thickness = thickness
        super.init(frame: .zero)
        backgroundColor = color
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError()
    }


    //  MARK: - Private API
    
    private func setup() {
        
        switch orientation {
        case .horizontal: heightAnchor.constraint(equalToConstant: thickness).isActive = true
        case .vertical: widthAnchor.constraint(equalToConstant: thickness).isActive = true
        }
    }
}
