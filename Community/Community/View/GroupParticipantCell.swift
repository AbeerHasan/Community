

import UIKit

class GroupParticipantCell: UITableViewCell {

    @IBOutlet weak var userImage: CircleImag!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var deletePtn: UIButton!
    @IBOutlet weak var containerView: GradientView!
    
    var uId: String?
    var admin: Bool?
    
    func configureCell(id: String, email: String, name: String, image: UIImage, admin: Bool){
        self.userEmail.text = email
        self.admin = admin
        
        if admin {
           self.userName.text =  name + " * Admin *"
        }else {
           self.userName.text = name
        }
        
        self.userImage.image = image
        self.uId = id
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            containerView.alpha = 0.2
            if self.admin! {
                userName.textColor = DarkPurple
                userEmail.textColor = DarkPurple
                deletePtn.isHidden = true
            }else {
                userName.textColor = DarkPurple
                userEmail.textColor = DarkPurple
                deletePtn.isHidden = false
            }
            
        }else {
            if self.admin! {
                containerView.alpha = 0.6
                userName.textColor = AppDarkBlue
                userEmail.textColor = AppDarkBlue
                  deletePtn.isHidden = true
            }else {
                 containerView.alpha = 1
                deletePtn.isHidden = true
                userName.textColor = UIColor.white
                userEmail.textColor = UIColor.white
            }
        }
    }
}
