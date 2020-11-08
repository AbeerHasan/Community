

import UIKit
import Firebase

class WritePostVC: UIViewController {

    @IBOutlet weak var userImage: CircleImag!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var sendPtn: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.userEmail.text = Auth.auth().currentUser?.email
    }
    
    @IBAction func closePtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendPtnPressed(_ sender: Any) {
        if contentTextView.text != "" && contentTextView.text != "Write Your Thoughts..." {
            sendPtn.isEnabled = false
            DataServices.instance.uploadPost(message: contentTextView.text, uid: Auth.auth().currentUser!.uid , groupKey: nil) { (success) in
                self.sendPtn.isEnabled = true
                
                if success {
                    self.dismiss(animated: true, completion: nil)
                }else {
                    print("Error in posting your post")
                }
            }
        }
    }
}
extension WritePostVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if Auth.auth().currentUser?.uid == nil {
            let logoutPopup = UIAlertController(title: "Can't write post", message: "You should login first to make a post", preferredStyle: .actionSheet)
            let logoutAction = UIAlertAction(title: "Login", style: .destructive) { (buttonTapped) in
                do {
                    let authVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                    self.present(authVC!, animated: true, completion: nil)
                } catch {
                    print(error)
                }
            }
            logoutPopup.addAction(logoutAction)
            present(logoutPopup, animated: true, completion: nil)
        }else {
            contentTextView.text = ""
        }
    }
}











