

import UIKit
import Firebase

class FullprofileVC: UIViewController {

    @IBOutlet weak var userImage: CircleImag!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser?.uid != nil {
            DataServices.instance.getUserData(uId: (Auth.auth().currentUser?.uid)!) { (name, email) in
                self.userName.text = name
                self.userEmail.text = email
            }
        }
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        //First action
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (buttonTapped) in
            do {
                try Auth.auth().signOut()
                self.userName.text = "User Name"
                self.userEmail.text = "Email@something.com"
                
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                self.present(authVC!, animated: true, completion: nil)
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
    
}
