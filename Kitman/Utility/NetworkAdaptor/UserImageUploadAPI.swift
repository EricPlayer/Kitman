//
//  UserImageUploadAPI.swift
//  Swagafied
//
//  Created by Amitabha on 27/01/17.
//  Copyright © 2017 Amitabha Saha. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class UserImageUploadAPI {
    
    var username: String = "QVVUSF9VU0VSX0lE"
    var userpassword: String = "QVVUSF9QQVNTV09SRA=="
    
    var userData: UserDetails!
    var didCompleteRequest:((_ success:Bool)->Void)?
    var dafaultUserID = Utility.getUserID()
    var image: UIImage!
    
    var message: String?
    var success: Bool? = false
    var errorCode: Int? = -1
    var errorMessage: String?
    
    // the default method is POST.
    var apiPath:String {
        
        var path = "http://webolation.com/sneakers/web_service/update_profile_picture?"
        if parameters.count == 1{
            for (key,value) in parameters{
                path = path + "\(key)=\(value)"
            }
        }else{
            for (key,value) in parameters{
                path = path + "\(key)=\(value)&"
            }
            path = path.substring(to: path.index(before: path.endIndex))
        }
        
        return path
    }
    
//    var parameters:[String : String] {
//        return ["user_id": Utility.getUserID(),"auth_user_id": username , "auth_password": userpassword]
//    }
    
    var parameters:[String : String] {
        return ["user_id": Utility.getUserID()]
    }
    
    func uploadImage(){
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = UIImageJPEGRepresentation(self.image, 1) {
                multipartFormData.append(imageData, withName: "uploadfile", fileName: "UserImage_\(Utility.getUserID()).PNG", mimeType: "image/PNG")
            }
            
            for (key, value) in self.parameters {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }}, to: apiPath, method: .post, headers: nil,
                encodingCompletion: { encodingResult in
                    
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON(completionHandler: {(response : DataResponse<Any>) in
                            self.handleResponse(response: response)
                        })
                        
                        break
                    case .failure(let encodingError):
                        print("error:\(encodingError)")
                    }
        })
        
    }
    
    func handleResponse(response: DataResponse<Any>) {
        
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
                    
                else if let isError = responseObject["as? String"] as? String{
                    // if there is error and it is a string
                    success = true
                    if isError == "invalid_credentials" {
                        errorCode = 401
                    }
                    didCompleteRequest?(false)
                    return
                }
                if success == true{
                    
                    userData = Mapper<UserDetails>().map(JSON: responseObject)
                    self.message = responseObject["msg"] as? String
                    
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
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
