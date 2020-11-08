

import UIKit

class AvatarPickerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var avatarsCollectionView: UICollectionView!
    
    // variables
    var avatarType = AvatarType.dark
    
    
    //---------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarsCollectionView.delegate =  self
        avatarsCollectionView.dataSource = self
    }
    
    //--------------------- Back button handling ------------------------------------------
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //------------------------ Segmented control ------------------------------------------
    @IBAction func segmentedControlPressed(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            avatarType = .dark
        }else {
            avatarType = .light
        }
        avatarsCollectionView.reloadData()
    }
    
    //------------------------ collection view settings -----------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //---------------------- cell content and click ---------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCollectionViewCell{
            cell.configureCell(index: indexPath.item, type: avatarType)
            return cell
        }
        return AvatarCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if avatarType == .dark {
        //    UserDataService.instance.setAvatarName(avatarName: "dark\(indexPath.item)")
        }else {
        //    UserDataService.instance.setAvatarName(avatarName: "light\(indexPath.item)")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //---------------- cell Size -----------------------------------------------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var numOfColumns : CGFloat = 3
        if UIScreen.main.bounds.width > 230 {
            numOfColumns = 4
        }
        
        let spaceBetweenCells : CGFloat = 10
        let padding : CGFloat = 40
        
        let cellsDimension : CGFloat = ((collectionView.bounds.width - padding) - (spaceBetweenCells * (numOfColumns - 1))) / numOfColumns
        
        return CGSize(width: cellsDimension, height: cellsDimension)
    }
    
}
