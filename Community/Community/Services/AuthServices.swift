

import Foundation
import Firebase

class AuthService {
    
    static let instance = AuthService()
    
    let defults = UserDefaults.standard
    
    var isLoggedIn : Bool {
        get {
            return defults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken : String {
        get {
            return defults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail : String {
        get {
            return defults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    
    func registerUser(name: String, email: String, password: String, completion: @escaping (_ status: Bool , _ error: Error?) -> () ){
        
        let lowerCassEmail = email.lowercased()
        
        Auth.auth().createUser(withEmail: lowerCassEmail, password: password) { (user, error) in
            guard let user = user  else {
                completion(false,error)
                return
            }
        
            let userData: [String: Any] = [
                "email" : user.user.email!,
                "name" : name,
                "provider" : user.user.providerID
            ]
            DataServices.instance.createDBUres(uid: user.user.uid, userData: userData)
            completion(true,nil)
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping  (_ status: Bool , _ error: Error?) -> () ){
        
        let lowerCassEmail = email.lowercased()
        
        Auth.auth().signIn(withEmail: lowerCassEmail, password: password) { (user, error) in
            guard let user = user  else {
                completion(false,error)
                return
            }
            
            let userData: [String: Any] = [
                "provider" : user.user.providerID,
                "email" : user.user.email!
            ]
            DataServices.instance.createDBUres(uid: user.user.uid, userData: userData)
            completion(true,nil)
        }

    }
}










