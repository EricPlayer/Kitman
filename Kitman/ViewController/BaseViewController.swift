 //
//  BaseViewController.swift
//  Tap House 23
//
//  Created by Amitabha on 04/07/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit
import MessageUI
import MapKit
import CoreLocation
import JSSAlertView
import MBProgressHUD

class BaseViewController: UIViewController,NavigationBarDelegate,MFMailComposeViewControllerDelegate {
    
    //var isUserCancelledLogin : Bool = false
    var navigationBar : NavigationBar = NavigationBar()
    var shadowImageView : UIImageView = UIImageView()
    
    typealias AlertCallBack = (()->())
    var cancelAlertAction : AlertCallBack?
    var okAlertAction : AlertCallBack?
    
    //var loginVCCancelled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationBar = NavigationBar()
        navigationBar.delegate = self
        self.view.addSubview(navigationBar)
        
        navigationBar.autoPinEdge(.top, to: .top, of: self.view)
        navigationBar.autoPinEdge(.trailing, to: .trailing, of: self.view)
        navigationBar.autoPinEdge(.leading, to: .leading, of: self.view)
        navigationBar.autoSetDimension(.height, toSize: Configuration.NavigationBar.NavigationBarHeight)
        
        //navigationBar.menuButton?.addTarget(self, action: #selector(BaseViewController.toogleMenu(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(shadowImageView)
        shadowImageView.image = UIImage(named: "dropShadow")
        shadowImageView.autoPinEdge(.top, to: .bottom, of: self.navigationBar)
        shadowImageView.autoPinEdge(.trailing, to: .trailing, of: self.view)
        shadowImageView.autoPinEdge(.leading, to: .leading, of: self.view)
        shadowImageView.autoSetDimension(.height, toSize: 15.0)
        self.shadowImageView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.didReceiveNotificationWithNotification(notification:)), name: NSNotification.Name(rawValue: Configuration.Notification.NoInternetNotification), object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // your code here
            DispatchQueue.main.async {
                self.view.bringSubview(toFront: self.navigationBar)
            }
        }
    }
    
    func loginCallBackAction(success:@escaping ()->Void, failure:@escaping ()->()){
        
        if !UserDefaults.standard.bool(forKey: Configuration.UserDefaultKeys.IsLoggedIn){
            
            // Get login signup view controller
            let loginSignupVC : LoginSignupViewController = loadViewControllerFromStroryboard(storyboard: Configuration.Storyboard.MainStoryBoard, viewControllerIndentifier: Configuration.ViewControllers.LoginSignupViewController) as! LoginSignupViewController
            loginSignupVC.callBackrequired = true
            
            // Present login signup view controller
            present(loginSignupVC, animated: true, completion: {
                
            })
            
            loginSignupVC.logInCallBack = {
                (finished)->() in
                
                // Login Successful
                if(finished){
                    loginSignupVC.dismiss(animated: true, completion: {
                        success()
                    })
                }else{
                    loginSignupVC.dismiss(animated: true, completion: {
                        failure()
                    })
                }
            }
            
            loginSignupVC.signUpCallBack = {
                (finished)->() in
                
                // Signup Successful
                if(finished){
                    loginSignupVC.dismiss(animated: true, completion: {
                        success()
                    })
                }else{
                    loginSignupVC.dismiss(animated: true, completion: {
                        failure()
                    })
                }
            }
            
            loginSignupVC.cancelActionCallBack = {
                () -> () in
                
                // User cancelled login/signup option
                loginSignupVC.dismiss(animated: true, completion: {
                    failure()
                })
            }
            
            
        }else{
            success()
        }
    }
    
    func tapped(){
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectPhoneOption() {
        if let url = NSURL(string: "tel://6106301600") {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    func didSelectTwitterOption(){
        
        if let url = NSURL(string: "http://www.twitter.com/GangsterVeganOG") {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    func didSelectFacebookOption(){
        
        if let url = NSURL(string: "http://www.facebook.com/Gangstervegan") {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    func didSelectInstagramOption(){
       
        if let url = NSURL(string: "http://www.instagram.com/gangsterveganorganics/") {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    func didSelectEmailOption() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setMessageBody(" ", isHTML: false)
        mailComposerVC.setToRecipients(["gangsterveganapp@gmail.com"])
        return mailComposerVC
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func sendMailForPrivateEvents(values:[String?]){
        
        var string : String?
        if values.count == 5{
             string = "Name : \(values[0]!) " + "\nCompany : \(values[1]!)" + "\nE-Mail : \(values[2]!)" + "\nPhone : \(values[3]!)" + "\nAddress : \(values[4]!)"
        }else if values.count == 4{
             string = "Name : \(values[0]!) " + "\nE-Mail : \(values[2]!)" + "\nPhone : \(values[3]!)" + "\nAddress : \(values[4]!)"
        }else{
            string = ""
        }
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setMessageBody(string!, isHTML: false)
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            
        }
    }
    
    func setToDefaultNavigationBar(){
        
        UIApplication.shared.statusBarStyle = .default
        self.navigationBar.backgroundColor = kWhiteColor
        self.navigationBar.appNameLabel?.text = "Kitman"
        self.navigationBar.appNameLabel?.textColor = kBlackColor
        self.navigationBar.appNameLabel?.font = Configuration.NavigationBar.NavigationBarFont
        
    }
    
    func showAlertView(title: String, message: String, cancelButtonTitle: String, okButtonTitle: String?){
        
        let alert = UIAlertController(title: title, message: message , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { (alertAction) -> Void in
            if let cancelAlert = self.cancelAlertAction{
                cancelAlert()
            }
        }))
        if let okTitle = okButtonTitle{
            alert.addAction(UIAlertAction(title: okTitle , style: UIAlertActionStyle.default, handler: { (alertAction) -> Void in
                if let okAlert = self.okAlertAction{
                    okAlert()
                }
            }))
        }
        
        DispatchQueue.main.async {
            if ( UserDefaults.standard.bool(forKey: Configuration.UserDefaultKeys.IsLoggedIn) == false )
            {
                self.present(alert, animated: true, completion: nil)
            }else{
                if let okAlert = self.okAlertAction{
                    okAlert()
                }
            }
        }
    }
    
    // MARK: - NavigationBar Delegate
    func didSelectLeftButton(sender:UIButton) {
        preconditionFailure("All subclasses must override didSelectLeftButton()")
    }
    
    func didSelectRightButton(sender:UIButton) {
        preconditionFailure("All subclasses must override didSelectRightButton()")
    }
    
    // MARK: - Notification - 
    @objc func didReceiveNotificationWithNotification(notification:NSNotification){
        
        let userinfo : Dictionary<String,String?> = notification.object as! Dictionary<String,String?>
        
//        if (Int(userinfo[Configuration.Notification.UserInfoKey]!)! == Configuration.NetworkError.InternetOffline || Int(userinfo[Configuration.Notification.UserInfoKey]!)! == Configuration.NetworkError.InternetNotReachable || Int(userinfo[Configuration.Notification.UserInfoKey]!)! == Configuration.NetworkError.InternetConnectionLost){
//            
//            JSSAlertView().danger((sharedAppDelegate.window?.rootViewController)!, title: "Internet issue", text: "Internet seems to be not connected.Please check the connection and try again")
//            
//        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
