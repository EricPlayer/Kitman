//
//  ProductDetail.swift
//  Swagafied
//
//  Created by Amitabha on 06/11/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
// ?=1

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class ProductDetail: APIBase {
    
    var product: ProductObject?
    var productID : String?
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
        
        var path = Configuration.API.Path.ProductDetails+"?"
        
        for (key,value) in parameters!{
            path = path + "\(key)=\(value)"
        }
        
        return path
    }
    
    override var parameterEncoding:ParameterEncoding {
        return URLEncoding.default
    }
    
    override var parameters:[String : Any]? {
        return ["product_id": productID ?? "1"]
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
                    
                    let responseLocalObject = Mapper<Productdetail>().map(JSON: responseObject)
                    print(responseLocalObject?.isSuccessful)
                    
                    self.message = responseLocalObject?.message
                    if let product = responseLocalObject?.product{
                        self.product = product
                    }
                    
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
