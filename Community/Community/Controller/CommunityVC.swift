
import UIKit
import  Firebase

class CommunityVC: UIViewController{
    
    //Outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: CircleImag!
    @IBOutlet weak var communitiesTable: UITableView!
    
    //vars
    var communities = [Community]()
    
    //View Funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUserData()
       
        //table view
        communitiesTable.delegate = self
        communitiesTable.dataSource = self
        
        //slidiing navigation menu
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width - 60
        //*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpUserData()
        DataServices.instance.REF_GROUPS.observe(.value) { (dataSnapShot) in
            DataServices.instance.getAllCommunities { (Communities) in
                self.communities = Communities
                self.communitiesTable.reloadData()
            }
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setUpUserData(){
        if Auth.auth().currentUser?.uid != nil {
            DataServices.instance.getUserData(uId: Auth.auth().currentUser!.uid) { (name, email) in
                self.loginBtn.setTitle(name, for: .normal)
            }
        }else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
            self.communities = [Community]()
            self.communitiesTable.reloadData()
        }
    }

    //actions
    @IBAction func addCommunityPressed(_ sender: Any) {
       if Auth.auth().currentUser != nil {
            let addCommunity = CreateCommunityVC_()
            addCommunity.modalPresentationStyle = .custom
            present(addCommunity, animated: true, completion: nil)
       }else {
        
       }
    }
   
    @IBAction func loginBtnPressed(_ sender: Any) {
        if Auth.auth().currentUser?.uid != nil {
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        }else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
}

extension CommunityVC: UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = communitiesTable.dequeueReusableCell(withIdentifier: "communityCell", for: indexPath) as? CommunityCell else {
            return UITableViewCell()}
        
        let community = communities[indexPath.row]
        cell.configureCell(community: community)
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let community = communities[indexPath.row]
        DataServices.instance.setSelectedCommunity(community: community )
        performSegue(withIdentifier: "viewchat", sender: self)
        
    }
}
