

import Foundation
import Firebase

class DataServices {
    static let instance = DataServices()
    
    private var _REF_BASE = FIREBASE_BASE_URL
    private var _REF_USERS = FIREBASE_BASE_URL.child("users")
    private var _REF_GROUPS = FIREBASE_BASE_URL.child("communities")
    private var _REF_FEED = FIREBASE_BASE_URL.child("feed")
   
    var REF_BASE :DatabaseReference {
        return _REF_BASE
    }
    var REF_USERS :DatabaseReference {
        return _REF_USERS
    }
    var REF_GROUPS :DatabaseReference {
        return _REF_GROUPS
    }
    var REF_FEED :DatabaseReference {
        return _REF_FEED
    }
    
    private var selectedCommunity : Community?
    func setSelectedCommunity(community: Community){
        self.selectedCommunity = community
    }
    var SELECTED_COMMUNITY : Community? {
        if selectedCommunity != nil {
            return selectedCommunity!
        }
        return nil
    }
    //---------------------------------------------------------
    func createDBUres(uid: String , userData: Dictionary<String , Any>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func getUserData(uId: String , handler: @escaping (_ userName: String , _ userEmail: String) -> ()){
        REF_USERS.observeSingleEvent(of: .value) { (usersSnapShot) in
            guard let usersSnapShot = usersSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in usersSnapShot {
                if user.key == uId {
                    handler(user.childSnapshot(forPath: "name").value as! String, user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    func uploadPost(message: String, uid: String, groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
        if groupKey != nil {
           REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content": message, "senderID": uid ])
             sendComplete(true)
        }else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderID": uid ])
            sendComplete(true)
        }
    }
    
    func getAllFeedMessages(handler: @escaping (_ messages : [Message]) -> ())  {
        REF_FEED.observeSingleEvent(of: .value, with: { (feedMessageSnapShot) in
            var messages = [Message]()
            
            guard let feedMessageSnapShot = feedMessageSnapShot.children.allObjects as? [DataSnapshot] else {return }
            
            for message in feedMessageSnapShot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let writerId = message.childSnapshot(forPath: "senderID").value as! String
                let msg = Message(id: message.key, content: content, uId: writerId, key: "")
                messages.append(msg)
            }
            handler(messages)
            
        }) { (Error) in
            print(String(Error.localizedDescription))
        }
    }
    
    func getAllGroupMessages(groupKey: String, handler: @escaping (_ messages : [Message]) -> ())  {
        REF_GROUPS.child(groupKey).child("messages").observeSingleEvent(of: .value, with: { (groupMessageSnapShot) in
            var messages = [Message]()
            
            guard let groupMessageSnapShot = groupMessageSnapShot.children.allObjects as? [DataSnapshot] else {return }
            
            for message in groupMessageSnapShot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let writerId = message.childSnapshot(forPath: "senderID").value as! String
                let msg = Message(id: message.key, content: content, uId: writerId, key: groupKey)
                messages.append(msg)
            }
            handler(messages)
            
        }) { (Error) in
            print(String(Error.localizedDescription))
        }
    }
    
    func getUsersWithName(searchQuery query: String, handler : @escaping (_ users: [User]) -> ()){
        REF_USERS.observeSingleEvent(of: .value, with: { (usersSnapShot) in
            var users = [User]()
            guard let _usersSnapShot = usersSnapShot.children.allObjects as? [DataSnapshot] else {return }
            
            for user in _usersSnapShot{
                let id = user.key
                let name = user.childSnapshot(forPath: "name").value as! String
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if name.lowercased().contains(query.lowercased()) && id != Auth.auth().currentUser?.uid && !DataServices.instance.SELECTED_COMMUNITY!.participants.contains(id){
                    let profilePic = #imageLiteral(resourceName: "defaultProfileImage")
                    let usr = User(name: name, uId: id, email: email, image: profilePic)
                    users.append(usr)
                }
            }
            handler(users)
            
        }) { (Error) in
            print(String(Error.localizedDescription))
        }
    }
    
    func createCommunity(uId: String, name: String, description: String, handler: @escaping(_ isCreated: Bool) -> ()){
        var members = [String]()
        members.append(uId)
        REF_GROUPS.childByAutoId().updateChildValues(["adminId" : uId , "name" : name, "description" : description, "participants" : members])
        handler(true)
    }
    
    func addCommunityParticipants(groupId: String, participants: [String], handler: @escaping(_ isCreated: Bool) -> ()){
        REF_GROUPS.observeSingleEvent(of: .value) { (groupsDataShot) in
            guard let _groupsDataShot = groupsDataShot.children.allObjects as? [DataSnapshot] else {return }
            for community in _groupsDataShot{
                let id = community.key
                if id == groupId {
                    let admin = community.childSnapshot(forPath: "adminId").value as! String
                    let name = community.childSnapshot(forPath: "name").value as! String
                    let description = community.childSnapshot(forPath: "description").value as! String
                    let _participants = participants
                    
                    self.REF_GROUPS.child(community.key).updateChildValues(["adminId" : admin, "name" : name, "description" : description, "participants" : _participants])
                }
            }
            handler(true)
            
        }
    }
    
    func getAllCommunities (handler: @escaping (_ Communities : [Community]) -> ()) {
        var communities = [Community]()
        REF_GROUPS.observeSingleEvent(of: .value) { (GroupsSnapShot) in
            guard let groupsSnapShot = GroupsSnapShot.children.allObjects as? [DataSnapshot] else {return }
            
            for group in groupsSnapShot {
                let admin = group.childSnapshot(forPath: "adminId").value as! String
                let participants = group.childSnapshot(forPath: "participants").value as! [String]
                if  Auth.auth().currentUser?.uid != nil {
                    
                    if  participants.contains( Auth.auth().currentUser!.uid) {
                        let name = group.childSnapshot(forPath: "name").value as! String
                        let description = group.childSnapshot(forPath: "description").value as! String
                        let community = Community(id: group.key, adminId: admin, name: name, description: description, participantsIds: participants)
                        communities.append(community)
                    }
                    handler(communities)
                }
            }
        }
    }
    
}














