

import UIKit
import GoogleSignIn

class CreateAccountVC: UIViewController, GIDSignInUIDelegate{
    
    //Outlets
    @IBOutlet weak var userNameText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var userAvatarImg: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //variables
    var avatarName = "profileDefault"
    var avatarColor = "[0.5,0.5,0.5,1]"
    var backgroundColor : UIColor?
    
    //------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        //GIDSignIn.sharedInstance().presentingViewController = self
        
       // GIDSignIn.sharedInstance()?.uiDelegate = self
       // GIDSignIn.sharedInstance()?.signInSilently()
        let gSignIn = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 230, height: 48))
        gSignIn.center = view.center
        view.addSubview(gSignIn)
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //   if UserDataService.instance.avatarName != "" {
        //     avatarName = UserDataService.instance.avatarName
        //   userAvatarImg.image = UIImage(named: avatarName)
        //}
        
    }
    
    
    @IBAction func createAccountPressed(_ sender: Any) {
        
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let name = userNameText.text, userNameText.text != "" else {return}
        guard let email = emailText.text, emailText.text != "" else {return}
        guard let password = passwordText.text, passwordText.text != "" else {return}
        AuthService.instance.registerUser(name: name ,email: email, password: password){
            (success , regError) in
            if success {
                print("Registered User :) with email : \(email) and password : \(password) ")
                AuthService.instance.loginUser(email: email, password: password, completion: {
                    (success , loginError) in
                    if success {
                        //AuthService.instance.createUser( name: name, email: email, avatarName: self.avatarName, avatarColor : self.avatarColor, completion: { (success) in
                          //  if success {
                                
                                self.spinner.isHidden = true
                                self.spinner.stopAnimating()
                                self.dismiss(animated: true, completion: nil)
                                //----------------------------------
                            //    self.performSegue(withIdentifier: UNWIND, sender: nil)
                              //  NotificationCenter.default.post(name: NOTIFICATION_DATA_CHANGED, object: nil)
                            //}
                     //   })
                    }
                })
            }else {
                print(String(regError?.localizedDescription ?? "Error :("))
            }
        }
    }
    
    @IBAction func choosePicPressed(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = true
        self.present(image, animated: true, completion: nil)
    }
   
  /*  @IBAction func chooseAvatarBackgroundPressed(_ sender: Any) {
        //----prepare random background color------
        let r = CGFloat(arc4random_uniform(255))/255
        let g = CGFloat(arc4random_uniform(255))/255
        let b = CGFloat(arc4random_uniform(255))/255
        
        backgroundColor = UIColor(displayP3Red: r, green: g, blue: b, alpha: 1)
        self.userAvatarImg.backgroundColor = backgroundColor
        
        // faiding animation -------------
        UIView.animate(withDuration: 0.2) {
            self.userAvatarImg.backgroundColor = self.backgroundColor
        }
        
        avatarColor = "[\(r),\(g),\(b),1]"
        
    }*/
    
    @IBAction func dismessBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    //---------- blaceholder text color ----------------------
    func setupView(){
        
        // Hidding the loading indicator
        spinner.isHidden = true
        
        //Hidding the keyboard after end writting
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }

}

extension CreateAccountVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userAvatarImg.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
}









