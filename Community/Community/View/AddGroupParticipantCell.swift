

import UIKit

class AddGroupParticipantCell: UITableViewCell {

    @IBOutlet weak var userImage: CircleImag!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var checkImage: CircleImag!
    @IBOutlet weak var container: UIView!
    
    var uId: String?
    var showing : Bool = false
    
    func configureCell(id: String, email: String, name: String, image: UIImage, isSelected: Bool){
        self.userEmail.text = email
        self.userName.text = name
        self.userImage.image = image
        self.uId = id
        if isSelected {
            checkImage.isHidden = false
       }else {
            checkImage.isHidden = true
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            userName.textColor = DarkPurple
            userEmail.textColor = DarkPurple
            if showing == false {
                checkImage.isHidden = false
                showing = true
            }else {
                checkImage.isHidden = true
               showing = false
            }
        }else {
            userName.textColor = UIColor.white
            userEmail.textColor = UIColor.white
        }
    }

}
