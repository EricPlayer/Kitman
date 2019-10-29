//
//  MasterDataParser.swift
//  Swagafied
//
//  Created by Amitabha on 21/03/17.
//  Copyright © 2017 Amitabha Saha. All rights reserved.
//

import Foundation

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import SwiftyJSON

class MasterDataParser: APIBase {
    
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
        
        return Configuration.API.Path.MasterData
    }
    
    override var parameterEncoding:ParameterEncoding {
        return URLEncoding.default
    }
    
    override var parameters:[String : Any]? {
        return nil
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
        else{
            didCompleteRequest?(false)
            return
        }
    }
    
}
