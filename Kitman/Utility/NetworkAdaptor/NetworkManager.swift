//
//  NetworkManager.swift
//  Swagafied
//
//  Created by Amitabha on 31/07/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import Foundation
import Alamofire
import JSSAlertView

class NetworkManager {
    static let sharedManager = NetworkManager()
    /**
     Initialization method
     
     - returns: Instance type of self
     */
    private init() {
        // initialize stuff
    }
    
    /**
     Get the API request
     
     - parameter apiObject: APIBase object contains all API Call related data
     
     - returns: AFRequest
     */
    func request(apiObject:APIBase) -> Request {
        QL1(apiObject.parameters)
        
        let apiPath = apiObject.apiPath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        return Alamofire.request((apiObject.baseURL + apiPath), method: apiObject.httpMethod, parameters: apiObject.parameters, encoding: apiObject.parameterEncoding, headers: apiObject.headers)
//        .downloadProgress(closure: apiObject.progressWrapper!)
        .responseJSON { (response : DataResponse<Any>) in
            
            QL1("URL: \(apiObject.baseURL + apiObject.apiPath)")
            
            if let httpError = response.result.error{
                let statusCode =  httpError._code
                QL2("\(type(of: apiObject)) api_error: \(statusCode)")
                
                if statusCode == 401 {
                    NetworkManager.sharedManager.checkAndHandle401(apiObject: apiObject)
                }
                
                if statusCode < -1000{
                    self.handleNetworkIssues(statusCode: statusCode)
                }
            }else { //no errors
                
                let statusCode = (response.response?.statusCode)
                QL2("\(type(of: apiObject)) api_success: \(statusCode)")
                if statusCode == 401 {
                    NetworkManager.sharedManager.checkAndHandle401(apiObject: apiObject)
                }
            }
            
            apiObject.handleResponse(response: response)
        }
    }
    
    func checkAndHandle401(apiObject:APIBase) {
        // handle the case of token expiry
        
    }
    
    func handleNetworkIssues(statusCode:Int){
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Configuration.Notification.NoInternetNotification), object: [Configuration.Notification.UserInfoKey: String(statusCode)])
        
        if (statusCode == Configuration.NetworkError.InternetConnectionLost){
            
        }else if (statusCode == Configuration.NetworkError.InternetOffline){
            
        }else if (statusCode == Configuration.NetworkError.InternetNotReachable){
            
        }
    }
    
}
