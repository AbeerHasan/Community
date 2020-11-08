

import UIKit
import Firebase

class ProfileVC: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var backGroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view.
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logOutBtnPressed(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        //First action
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (buttonTapped) in
            do {
                try Auth.auth().signOut()
                self.userName.text = "User Name"
                self.userEmail.text = "Email@something.com"
                self.dismiss(animated: true, completion: nil)
               } catch {
                print(error)
            }
        }
        logoutPopup.addAction(logoutAction)
        //second acction
        let cancel = UIAlertAction(title: "cancel", style: .destructive) { (buttonTapped) in
            self.dismiss(animated: true, completion: nil)
        }
        logoutPopup.addAction(cancel)
        present(logoutPopup, animated: true, completion: nil)
    }
    
    func setUpView(){
        if Auth.auth().currentUser?.uid != nil {
            DataServices.instance.getUserData(uId: Auth.auth().currentUser!.uid) { (name, email) in
                self.userName.text = name
                self.userEmail.text = email
                self.userImage.image = UIImage(named: "")
            }
        }
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeTap(_:)))
        backGroundView.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
}
