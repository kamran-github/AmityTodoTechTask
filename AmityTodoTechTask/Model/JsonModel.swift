
import Foundation
import ObjectMapper

struct TodoModel : Mappable {
	var todo : [Todo]?
	var user : [User]?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		todo <- map["todo"]
		user <- map["user"]
	}

}


struct Todo : Mappable {
    var id : String?
    var title : String?
    var description : String?
    var userId : String?
    var createdAt : String?
    var c_date : Date?
    var avatar : String?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        title <- map["title"]
        description <- map["description"]
        userId <- map["userId"]
        createdAt <- map["createdAt"]
        c_date <- map["c_date"]
        avatar <- map["avatar"]
    }

}


struct User : Mappable {
    var id : String?
    var name : String?
    var avatar : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        avatar <- map["avatar"]
    }

}
