

import UIKit

class InputTextField: UITextField {
    
   // private var padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    
    override func awakeFromNib() {
        setupView()
        super.awakeFromNib()
    }

    func setupView(){
        // Coloring the textfields text
      let placeHolder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : PurplePlaceHolder])
        
        self.attributedPlaceholder = placeHolder
        self.textColor = #colorLiteral(red: 0.2092700755, green: 0.5067031534, blue: 0.6108224937, alpha: 1)
        self.adjustsFontSizeToFitWidth = true
    }
}
