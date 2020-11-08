

import UIKit
@IBDesignable

class CircleImag: UIImageView {
    
    
    override func awakeFromNib() { // to make the design appears at run time
        self.setUpView()
    }
    override func prepareForInterfaceBuilder() { // to make the design appears on the storyboard
        super.prepareForInterfaceBuilder()
        self.setUpView()
    }
    
    func setUpView(){
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true 
    }


}
