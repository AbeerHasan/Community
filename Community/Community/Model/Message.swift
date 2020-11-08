

import Foundation

class Message {
    private var _id: String!
    private var _content : String
    private var _uId  : String
    private var _key: String!
    
    var id : String {
        return _id
    }
    
    var content : String {
        return _content
    }
    
    var uId : String {
        return _uId
    }
    
    
    var key : String {
        return _key
    }
    
    init(id: String, content: String, uId: String ,key: String) {
        self._id = id
        self._content = content
        self._uId = uId
        self._key = key
    }
}
