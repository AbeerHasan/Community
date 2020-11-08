

import UIKit

class CommunityCell: UITableViewCell {

    @IBOutlet weak var communityNameLable: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            communityNameLable.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        }else {
            communityNameLable.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureCell(community: Community){
        let title = community.name 
        communityNameLable.text = title
        
    }
}
