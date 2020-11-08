
import UIKit
import Firebase

class CreateCommunityVC_: UIViewController {
    @IBOutlet weak var backGround: UIView!
    
    @IBOutlet weak var nameText: InputTextField!
    @IBOutlet weak var descriptionText: InputTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setupView()
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createPressed(_ sender: Any) {
        if nameText.text != "" && nameText.text != " " {
            if descriptionText.text == "" {
                descriptionText.text = " "
            }
            DataServices.instance.createCommunity(uId: Auth.auth().currentUser!.uid, name: nameText.text!, description: descriptionText.text!) { (success) in
                if success {
                    self.dismiss(animated: true,completion: nil)
                }else {
                    print("Error")
                }
            }
        }
    }
    
    func setupView(){
        
        // Hidding the loading indicator
        //        spinner.isHidden = true
      
        //Hidding the keyboard after end writting
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(CreateCommunityVC_.closeTap(_:)))
        backGround.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
}
