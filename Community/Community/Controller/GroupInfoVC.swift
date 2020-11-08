

import UIKit
import Firebase

class GroupInfoVC: UIViewController {

    @IBOutlet weak var communityNameLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var participantsTableView: UITableView!
    @IBOutlet weak var addParticipantsBtn: UIButton!
    
    var participants = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        participantsTableView.delegate = self
        participantsTableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser!.uid != DataServices.instance.SELECTED_COMMUNITY!.participants[0] {
            addParticipantsBtn.isHidden = true
        }else {
            addParticipantsBtn.isHidden = false
        }
        
        communityNameLable.text = DataServices.instance.SELECTED_COMMUNITY!.name
        descriptionLable.text = DataServices.instance.SELECTED_COMMUNITY!.description
        for p in DataServices.instance.SELECTED_COMMUNITY!.participants {
            DataServices.instance.getUserData(uId: p) { (Name, Email) in
                let user = User(name: Name, uId: p, email: Email, image: #imageLiteral(resourceName: "profileDefault"))
                if !self.participants.contains(where: { (_user) -> Bool in
                    if _user.uId == user.uId {
                       return true
                    }
                    return false
                }){
                    self.participants.append(user)
                }
            }
        }
         participantsTableView.reloadData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        participantsTableView.reloadData()
    }
    @IBAction func backPtnPressed(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
   
}

extension GroupInfoVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = participantsTableView.dequeueReusableCell(withIdentifier: "userGroupCell") as? GroupParticipantCell else {return UITableViewCell()}
        var admin = false
        if indexPath.row == 0 {
            admin = true
        }else {
            admin = false
        }
        cell.configureCell(id: participants[indexPath.row].uId
            , email: participants[indexPath.row].email, name:  participants[indexPath.row].name, image: participants[indexPath.row].image, admin: admin)
        return cell
    }
    
    
}
