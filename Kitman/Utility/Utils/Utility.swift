//
//  Utility.swift
//  Swagafied
//
//  Created by Amitabha on 21/08/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import JSSAlertView

class Utility{
    
    class func getEmailID() -> String?{
        return UserDefaults.standard.value(forKey: "userEmailID") as! String?
    }
    
    class func getUserName() -> String?{
        return UserDefaults.standard.value(forKey: "userNameID") as! String?
    }
    
    class func getUserID() -> String{
        return UserDefaults.standard.value(forKey: Configuration.UserDefaultKeys.UserID) as? String ?? "1"
    }
    
    class func removeUserData() {
        
        UserDefaults.standard.removeObject(forKey: Configuration.UserDefaultKeys.UserID)
        UserDefaults.standard.removeObject(forKey: "userEmailID")
        UserDefaults.standard.removeObject(forKey: "userNameID")
        UserDefaults.standard.set(false, forKey: Configuration.UserDefaultKeys.IsLoggedIn)
        UserDefaults.standard.removeObject(forKey: "User.password")
        UserDefaults.standard.removeObject(forKey: "User.email")
        
        UserDefaults.standard.synchronize()
    }
    
    class func getDeviceID() -> String? {
        
        if let retrievedString = KeychainWrapper.standard.string(forKey: Configuration.DeviceInfo.DeviceID){
            return retrievedString
        }else{
            let device_id : String = (UIDevice.current.identifierForVendor?.uuidString)!
            if ( KeychainWrapper.standard.set(device_id, forKey: Configuration.DeviceInfo.DeviceID) ){
                return device_id
            }else{
                return nil
            }
        }
    }
    
    class func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValidPassword(testStr:String) -> Bool{
        let passowrdReEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[~!@#$%^&*()_]).{8,15}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", passowrdReEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func showErrorAlert(message: String){
        JSSAlertView().danger((sharedAppDelegate.window?.rootViewController)!, title: "Error", text: message)
    }
    
    class func getLaunchDate() -> Date? {
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        var components = DateComponents()
        components.year = 2017
        components.month = 3
        components.day = 31
        components.hour = 12
        components.minute = 0
        components.second = 0
        
        return calendar.date(from: components)
    }
    
    class func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
