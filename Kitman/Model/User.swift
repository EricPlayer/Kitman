//
//  User.swift
//  Swagafied
//
//  Created by Amitabha on 06/08/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit
import ObjectMapper

class User: NSObject {
    
    static let sharedUser = User()
    var userModel : UserModel?
    
    var userLoggedIn: Bool{
        get{
            return UserDefaults.standard.value(forKey: "Configuration.UserDefaultKeys.IsLoggedIn") as! Bool
        }
    }
    
    override required init() {
        
    }
    
    func clearData(){
        userModel = nil
        
        removeForKey(key: "userName")
        removeForKey(key: "userEmailID")
        removeForKey(key: "firstName")
        removeForKey(key: "lastName")
        removeForKey(key: "company")
        removeForKey(key: "website")
        removeForKey(key: "phone")
        removeForKey(key: "city")
        removeForKey(key: "state")
        removeForKey(key: "zip")
        removeForKey(key: "country")
        removeForKey(key: "dateOfBirth")
        removeForKey(key: Configuration.UserDefaultKeys.IsLoggedIn)
    }
    
    func removeForKey(key: String){
        
        let Keyy = "com.swagafied.user\(key)"
        UserDefaults.standard.removeObject(forKey: Keyy)
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(userModel, forKey: "userModel")
    }
}

class UserModel: Mappable {
    
    var userName : String = ""
    var userEmailID : String = ""
    var userID : String = "12345"
    var addedDate : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var dateOfBirth : String = ""
    var company : String = ""
    var website : String = ""
    var phone : String = ""
    var city : String = ""
    var state : String = ""
    var zip : String = ""
    var country : String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        //userName <- map["user_details.user_name"]
        userID <- map["user_details.id"]
        userEmailID <- map["user_details.email"]
        addedDate <- map["user_details.added_date"]
        userName <- map ["user_details.username"]
        
        UserDefaults.standard.set(userName, forKey: "userNameID")
        UserDefaults.standard.set(userID, forKey: Configuration.UserDefaultKeys.UserID)
        UserDefaults.standard.synchronize()
    }
}
