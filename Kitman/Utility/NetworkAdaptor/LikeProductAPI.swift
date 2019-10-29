//
//  LikeProductAPI.swift
//  Swagafied
//
//  Created by Amitabha on 06/08/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class LikeProductAPI: APIBase {
    
    var dafaultUserID = Utility.getUserID()
    var productID = "12345"
    
    var products: Array<ProductObject> = Array<ProductObject>()
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
        
        var path = Configuration.API.Path.ProductLike+"?"
    
        if parameters?.count == 1{
            for (key,value) in parameters!{
                path = path + "\(key)=\(value)"
            }
        }else{
            for (key,value) in parameters!{
                path = path + "\(key)=\(value)&"
            }
            path = path.substring(to: path.index(before: path.endIndex))
        }
        
        return path
    }
    
    override var parameterEncoding:ParameterEncoding {
        return URLEncoding.default
    }
    
    override var parameters:[String : Any]? {
        return ["user_id":Utility.getUserID() as AnyObject,"product_id":productID]
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
                    print(responseObject)
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
