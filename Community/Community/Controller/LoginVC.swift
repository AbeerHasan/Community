

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var userNameTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var Spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction func dismissBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        Spinner.isHidden = false
        Spinner.startAnimating()
        
        guard let email = userNameTxt.text, userNameTxt.text != "" else {return}
        guard let password = passwordTxt.text, passwordTxt.text != "" else {return}
        
        AuthService.instance.loginUser(email: email, password: password) { (success, loginError) in
            if success {
                self.Spinner.isHidden = true
                self.Spinner.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            }else {
                print(String(loginError!.localizedDescription))
            }
        }
    }
    
    
    func setupView(){
        
        // Hidding the loading indicator
        Spinner.isHidden = true
        
        //Hidding the keyboard after end writting
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }

}
