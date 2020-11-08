
import Foundation
import Firebase




//Notification types
let NOTIFICATION_DATA_CHANGED =  Notification.Name("notifUserDataChanged")

//segues
let TO_LOGIN = "toLogIn"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToCommunities"
let AVATAR_PICKER = "toAvatarPickerVC"

//colors
let PurplePlaceHolder = #colorLiteral(red: 0.3529411765, green: 0.7411764706, blue: 0.8549019608, alpha: 0.6)
let DarkPurple = #colorLiteral(red: 0.2388770053, green: 0.508429612, blue: 0.5925007931, alpha: 1)
let AppBlue = #colorLiteral(red: 0.2235294118, green: 0.4862745098, blue: 0.7294117647, alpha: 1)
let AppDarkBlue = #colorLiteral(red: 0.1725490196, green: 0.3725490196, blue: 0.5568627451, alpha: 1)

//user defults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

typealias completionHandler = (_ Success: Bool) -> ()
//url constants
let BASE_URL = "https://communitychatapp.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_Get_Communities = "\(BASE_URL)channel"

let FIREBASE_BASE_URL = Database.database().reference()

//Headers
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]
let BEARER_HEADER =  ["Authorization":"Bearer \(AuthService.instance.authToken)",
    "Content-Type": "application/json; charset=utf-8"]
