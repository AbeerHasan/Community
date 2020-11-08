
import UIKit
@IBDesignable

class RoundedButton: UIButton {
    
    @IBInspectable var cornerRadius : CGFloat = 10.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() { // to make the design appears at run time
        self.setUpView()
    }
    override func prepareForInterfaceBuilder() { // to make the design appears on the storyboard
        super.prepareForInterfaceBuilder()
        self.setUpView()
    }
    
    func setUpView(){
        self.layer.cornerRadius = cornerRadius
    }


}
