

import Foundation

struct Community{
    private var _id: String!
    private var _adminId: String!
    private var _name: String!
    private var _description: String!
    private var _participantsIds: [String]!
    
    init(id: String, adminId: String, name: String, description: String, participantsIds: [String]) {
        self._id = id
        self._adminId = adminId
        self._name = name
        self._description = description
        self._participantsIds = participantsIds
    }
    
    var  id: String {
        return _id
    }
    
    var  name: String {
        return _name
    }
    var  description: String {
        return _description
    }
    var  adminId: String {
        return _adminId
    }
    var  participants: [String] {
        return _participantsIds
    }
    
    mutating func setParticipants(participants: [String]){
        self._participantsIds = participants
    }
}
