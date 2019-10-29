//
//  UserProfileUpdateAPI.swift
//  Swagafied
//
//  Created by Amitabha on 08/11/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class UserProfileUpdateAPI: APIBase {
    
    var paramList1 : [String : Any]?
    var paramList2 : [String : Any]?
    var paramList3 : [String : Any]?
    var paramList4 : [String : Any]?
    var apiPathString : String?
    var dafaultUserID =  Utility.getUserID()
    var message:String?
    var success:Bool? = false
    var errorCode:Int? = -1
    var errorMessage:String?
    
    // the default method is POST.
    override var httpMethod:Alamofire.HTTPMethod {
        return .post
    }
    
    override var shouldSendToken:Bool{
        return false
    }
    
    override var apiPath:String {
        
        var path = Configuration.API.Path.UpdateUser+"?"
        
        for (key,value) in parameters!{
            path = path + "\(key)=\(value)&"
        }
        
        path = path.substring(to: path.index(before: path.endIndex))
        path = path.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        return path
    }
    
    override var parameterEncoding:ParameterEncoding {
        return URLEncoding.default
    }
    
    override var parameters:[String : Any]? {
        let dic : [String : Any]!
        dic = paramList1!.mergedWith(otherDictionary: paramList2!).mergedWith(otherDictionary: paramList3!).mergedWith(otherDictionary: paramList4!) as [String : AnyObject]!
        return dic!
        
//        return ["product_id":  "1"]
    }
    
    override func handleResponse(response: DataResponse<Any>) {
        
        if let apiResponse =  response.result.value{
            
            if (response.result.error != nil) {
                didCompleteRequest?(false)
            }
            else {
                
                guard let responseObject = apiResponse as? [String : Any]
                    else {
                        if let httpCode = response.result.error?._code {
                            errorCode = httpCode
                        }
                        didCompleteRequest?(false)
                        return
                }
                
                if let isError = responseObject["success"] as? Bool{
                    success = isError
                }
                else if let isError = responseObject["error"] as? String{
                    // if there is error and it is a string
                    success = true
                    if isError == "invalid_credentials" {
                        errorCode = 401
                    }
                    didCompleteRequest?(false)
                    return
                }
                if success == true{
                    
                    if let apiResponseMessage = responseObject["msg"]{
                        self.message = apiResponseMessage as? String
                    }
                }
                else{
                    if let error_Code = responseObject["errorCode"] as? Int{
                        errorCode = error_Code
                    }
                }
                
                didCompleteRequest?(true)
            }
        }
    }

}

extension Dictionary {
    func mergedWith(otherDictionary: [Key: Value]) -> [Key: Value] {
        var mergedDict: [Key: Value] = [:]
        [self, otherDictionary].forEach { dict in
            for (key, value) in dict {
                mergedDict[key] = value
            }
        }
        return mergedDict
    }
}
