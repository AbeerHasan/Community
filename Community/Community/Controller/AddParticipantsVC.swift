

import UIKit

class AddParticipantsVC: UIViewController {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var searchUserTextField: InputTextField!
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var addBtn: RoundedButton!
    @IBOutlet weak var participantsTableView: UITableView!
    
    var users = [User]()
    var choosenUsers = [User]()
    var choosenIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTableView.delegate = self
        usersTableView.dataSource = self
        participantsTableView.delegate = self
        participantsTableView.dataSource = self
        
        searchUserTextField.delegate = self
        searchUserTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
         usersTableView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addBtn.isHidden = false
    }
    
    @objc func textFieldDidChanged(){
        if searchUserTextField.text == "" {
            users = []
            usersTableView.reloadData()
            usersTableView.isHidden = true
        }else {
            usersTableView.isHidden = false
            DataServices.instance.getUsersWithName(searchQuery: searchUserTextField.text!) { (Users) in
                self.users = Users
                self.usersTableView.reloadData()
            }
        }
    }
    @IBAction func backPtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPtnPressed(_ sender: Any) {
        var comunity = DataServices.instance.SELECTED_COMMUNITY!
        var allParticipants = DataServices.instance.SELECTED_COMMUNITY!.participants
        allParticipants.append(contentsOf: choosenIds)
     
        DataServices.instance.addCommunityParticipants(groupId: comunity.id , participants: allParticipants) { (success) in
            comunity.setParticipants(participants: allParticipants)
            DataServices.instance.setSelectedCommunity(community: comunity)

            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension AddParticipantsVC: UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == usersTableView {
            return users.count
        }else {
            return choosenUsers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == usersTableView {
            guard let cell = usersTableView.dequeueReusableCell(withIdentifier: "addGroupUserCell") as? AddGroupParticipantCell else {return UITableViewCell()}
            let image: UIImage = UIImage(named: "profileDefault")!
            cell.configureCell(id:users[indexPath.row].uId ,email: users[indexPath.row].email, name: users[indexPath.row].name, image: image, isSelected: false)
            return cell
        }else {
            guard let cell = participantsTableView.dequeueReusableCell(withIdentifier: "addedParticipants") as? AddGroupParticipantCell else {return UITableViewCell()}
            let image: UIImage = UIImage(named: "profileDefault")!
            cell.configureCell(id: choosenUsers[indexPath.row].uId ,email: choosenUsers[indexPath.row].email, name: choosenUsers[indexPath.row].name, image: image, isSelected: true)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == usersTableView {
            
            guard let cell = usersTableView.cellForRow(at: indexPath) as? AddGroupParticipantCell else {return}
            if !choosenIds.contains(cell.uId!){
                choosenIds.append(cell.uId!)
                addBtn.isHidden = false
                let user = User(name: cell.userName.text!, uId: cell.uId! , email: cell.userEmail.text!, image: #imageLiteral(resourceName: "me-tabIcon"))
                choosenUsers.append(user)
            }else {
                choosenIds = choosenIds.filter({ $0 != cell.uId})
                choosenUsers = choosenUsers.filter({ $0.uId != cell.uId})
                if choosenIds.count >= 1 {
                    addBtn.isHidden = false
                }else {
                    addBtn.isHidden = true
                }
            }
            participantsTableView.reloadData()
        }else {
            
        }
        
    }
}
