//
//  APIBase.swift
//  Swagafied
//
//  Created by Amitabha on 31/07/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import Foundation
import Alamofire

class APIBase {
    
    // override this methd in subclasses to set HTTP method
    var httpMethod:Alamofire.HTTPMethod {
        return .post
    }
    
    var shouldSendToken:Bool {
        return true
    }
    
    var shouldPersistData:Bool = true
    
    var baseURL:String {
        // you do not need to override this
        return Configuration.API.shouldUseProductionURL ? Configuration.API.baseAPIURLproduction : Configuration.API.baseAPIUrlStating
    }
    
    // this is the api path eg: {users/134/profile/photo}
    var apiPath:String {
        return ""
    }
    
    // set your request parameters (if any)
    var parameters:[String : Any]? {
        return nil
    }
    
    var parameterEncoding:ParameterEncoding {
        return URLEncoding.default
    }
    
    var headers:[String : String]?
    
    /*
 
     var progressWrapper:((Int64, Int64, Int64) -> Void)? {
     guard  let progress = progress else {
     return nil
     }
     
     return { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
     let p = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
     dispatch_async(dispatch_get_main_queue(), { () -> Void in
     if p < 0 {
     // if progress value is unknown because there i
     progress(0.0)
     } else {
     progress(CGFloat(p))
     }
     })
     }
     }
     
     // set this variable from the place the api is used
     var progress:((CGFloat)->Void)?
 
    */
    
    var progressWrapper:((Progress) -> Void)? {
        
        guard  let progress = progress else {
            return nil
        }
        
        return { proessValue in
            let p = proessValue.fractionCompleted
            
            DispatchQueue.main.async {
                if p < 0 {
                    // if progress value is unknown because there i
                    progress(0.0)
                } else {
                    progress(CGFloat(p))
                }
            }
        }
    }
    
    // set this variable from the place the api is used
    var progress:((_ progresValue: CGFloat)->Void)?
    
    var didCompleteRequest:((_ success:Bool)->Void)?
    
    func handleResponse(response: DataResponse<Any>) {
        // abstract
    }
    
    /*
    func lastSyncedDate() -> NSDate {
        var lastSyncTimeStamps:[String:NSDate]? = UserDefaultsUtil.sharedUserDefaults().objectForKey(Constants.UserDefaultKeys.lastSynced) as? [String:NSDate]
        
        let apiKey =  "\(Constants.UserDefaultKeys.lastSynced)\(self.dynamicType)"
        
        if lastSyncTimeStamps != nil {
            if let lastSynced = lastSyncTimeStamps![apiKey] {
                return lastSynced
            } else {
                lastSyncTimeStamps![apiKey] = NSDate.getDateFromString(Constants.Configurable.defaultLastSyncedDate, dateFormat: Constants.DateFormats.APITimeStampFormat)!
            }
        } else {
            lastSyncTimeStamps = [String:NSDate]()
            lastSyncTimeStamps?[apiKey] = NSDate.getDateFromString(Constants.Configurable.defaultLastSyncedDate, dateFormat: Constants.DateFormats.APITimeStampFormat)!
        }
        
        UserDefaultsUtil.sharedUserDefaults().setObject(lastSyncTimeStamps, forKey: Constants.UserDefaultKeys.lastSynced)
        UserDefaultsUtil.sharedUserDefaults().synchronize()
        
        return lastSyncTimeStamps![apiKey]!
    }
    
    func lastSyncedDateString() -> String {
        return lastSyncedDate().getDateString(Constants.DateFormats.APITimeStampFormat)!
    }
    
    func updateLastSyncedDate() {
        var lastSyncTimeStamps:[String:NSDate]? = UserDefaultsUtil.sharedUserDefaults().objectForKey(Constants.UserDefaultKeys.lastSynced) as? [String:NSDate]
        
        let apiKey =  "\(Constants.UserDefaultKeys.lastSynced)\(self.dynamicType)"
        
        if lastSyncTimeStamps != nil {
            lastSyncTimeStamps?[apiKey] = NSDate()
        } else {
            lastSyncTimeStamps = [String:NSDate]()
            lastSyncTimeStamps?[apiKey] = NSDate()
        }
        
        UserDefaultsUtil.sharedUserDefaults().setObject(lastSyncTimeStamps, forKey: Constants.UserDefaultKeys.lastSynced)
        UserDefaultsUtil.sharedUserDefaults().synchronize()
    }
    */
}
