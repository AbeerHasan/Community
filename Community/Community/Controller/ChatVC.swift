

import UIKit
import Firebase

class ChatVC: UIViewController {

    @IBOutlet weak var menuBtn: UIButton!
   
    @IBOutlet weak var messageContent: UITextView!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var communityNameLable: UILabel!
    @IBOutlet weak var groupInfoBtn: UIButton!
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        //sliding
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        //delegates
        messageContent.delegate = self
        messagesTableView.delegate = self
        messagesTableView.dataSource = self 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if DataServices.instance.SELECTED_COMMUNITY != nil {
            
            communityNameLable.text = DataServices.instance.SELECTED_COMMUNITY?.name
            groupInfoBtn.isHidden = false
            
            DataServices.instance.REF_GROUPS.observe(.value) { (snapShot) in
                DataServices.instance.getAllGroupMessages(groupKey: DataServices.instance.SELECTED_COMMUNITY!.id, handler: { (_messages) in
                    self.messages = _messages
                    self.messagesTableView.reloadData()
                    
                    if !self.messages.isEmpty {
                        self.messagesTableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .none, animated: true)
                    }
                })
            }
        }else {
            communityNameLable.text = "No Opened Community"
            groupInfoBtn.isHidden = true
        }
    }
   
    
    @IBAction func sendPtnPressed(_ sender: Any) {
        if messageContent.text != ""{
            DataServices.instance.uploadPost(message: messageContent.text!, uid: Auth.auth().currentUser!.uid , groupKey: DataServices.instance.SELECTED_COMMUNITY!.id) { (success) in
                let message = Message(id: "", content: self.messageContent.text!, uId: Auth.auth().currentUser!.uid, key: DataServices.instance.SELECTED_COMMUNITY!.id)
                self.messages.append(message)
                self.messageContent.text = "Write your message..."
                self.messageContent.endEditing(true)
            }
            messagesTableView.reloadData()
        }
    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let image = UIImage(named: "profileDefault")
        
        if message.uId == Auth.auth().currentUser!.uid {
            guard let cell = messagesTableView.dequeueReusableCell(withIdentifier: "currentUserMessageCell") as? FeedCell else {return UITableViewCell()}
            DataServices.instance.getUserData(uId: message.uId) { (uName, uEmail) in
                cell.configureCell(image: image!,name: uName , email:uEmail, content: message.content,inGroup: true)
            }
             return cell
        }else {
             guard let cell = messagesTableView.dequeueReusableCell(withIdentifier: "messageCell") as? FeedCell else {return UITableViewCell()}
            DataServices.instance.getUserData(uId: message.uId) { (uName, uEmail) in
                cell.configureCell(image: image!,name: uName , email:uEmail, content: message.content,inGroup: true)
            }
             return cell
        }
    }
}

extension ChatVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        messageContent.text = ""
        if Auth.auth().currentUser?.uid == nil {
            let loginPopup = UIAlertController(title: "Can't write messages", message: "You should login first to make a post", preferredStyle: .actionSheet)
            let loginAction = UIAlertAction(title: "Login", style: .destructive) { (buttonTapped) in
                do {
                    let authVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                    self.present(authVC!, animated: true, completion: nil)
                }
            }
            loginPopup.addAction(loginAction)
            present(loginPopup, animated: true, completion: nil)
        }else if DataServices.instance.SELECTED_COMMUNITY == nil {
            let chooseCommunityPopUp = UIAlertController(title: "Can't write messages", message: "You should Choose Community first to write for them", preferredStyle: .actionSheet)
            let chooseCommunityAction = UIAlertAction(title: "choose community", style: .destructive) { (buttonTapped) in
                do {
                   self.performSegue(withIdentifier: "showCommunities", sender: nil)
                }
            }
            chooseCommunityPopUp.addAction(chooseCommunityAction)
            present(chooseCommunityPopUp, animated: true, completion: nil)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
         if messageContent.text != ""{
            if messageContent.text! == " "{
                self.messageContent.text = "Write your message..."
                self.messageContent.endEditing(true)
            }
        }
    }
    
}
