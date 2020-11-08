

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    @IBOutlet weak var writerName: UILabel!
    @IBOutlet weak var writerEmail: UILabel!
    @IBOutlet weak var writerImage: CircleImag!
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var currentUserMessage: UILabel!
    
    func configureCell(image: UIImage,name: String , email: String, content: String, inGroup: Bool ){
        if inGroup && email == Auth.auth().currentUser?.email {
            currentUserMessage.text = content
        }else {
            writerName.text = name
            writerImage.image = image
            postContent.text = content
            if !inGroup {
                self.writerEmail.text = email
            }
        }
    }
   

}
