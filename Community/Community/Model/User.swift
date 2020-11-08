
import Foundation

class User {
    private var _uId  : String
    private var _name : String
    private var _email : String
    private var _image : UIImage
    
    var name : String {
        return _name
    }
    var uId : String {
        return _uId
    }
    var email : String {
        return _email
    }
    var image : UIImage {
        return _image
    }
    
    init(name: String, uId: String, email: String, image: UIImage) {
        self._name = name
        self._uId = uId
        self._email = email
        self._image = image
    }
}
