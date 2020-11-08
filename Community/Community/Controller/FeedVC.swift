

import UIKit

class FeedVC: UIViewController {

    @IBOutlet weak var feedTableView: UITableView!
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataServices.instance.getAllFeedMessages { (allMessages) in
            self.messages = allMessages.reversed()
            self.feedTableView.reloadData()
        }
    }

}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell
             else { return UITableViewCell() }
        let image = UIImage(named: "profileDefault")
        let message = messages[indexPath.row]
        DataServices.instance.getUserData(uId: message.uId) { (uName, uEmail) in
            cell.configureCell(image: image!,name: uName , email: "    " + uEmail, content: message.content,inGroup: false)
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
