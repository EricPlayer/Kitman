//
//  WindowManager.swift
//  Swagafied
//
//  Created by Amitabha on 15/10/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit

class WindowManager {
    
    static let sharedManager = WindowManager()
    var rootWindow:UIWindow
    var menuVC:UIViewController?
    var seperatorView:UIView?
    
    private init() {
        rootWindow = (UIApplication.shared.delegate?.window!)!
        
        let mainStoryBoard =  UIStoryboard(name: Configuration.Storyboard.MainStoryBoard , bundle: nil)
        menuVC = mainStoryBoard.instantiateViewController(withIdentifier: Configuration.StoryboardVC.RightMenuViewController)
        
        seperatorView = UIView( frame: CGRect(x:0, y:0, width: Configuration.Sizes.ScreenWidth,height: Configuration.Sizes.ScreenHeight))
        seperatorView?.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
//        let touchRecognizer = UITapGestureRecognizer(target: menuVC, action:Selector("hideMenuOption"))
//        touchRecognizer.numberOfTapsRequired = 1
//        touchRecognizer.numberOfTouchesRequired = 1
//        seperatorView?.addGestureRecognizer(touchRecognizer)
    }
    
    func hideMenuVC (sender:UITapGestureRecognizer){
        self.hideMenu()
    }
    
    func showViewController(viewController: UIViewController){
        rootWindow.rootViewController = viewController
        rootWindow.makeKeyAndVisible()
    }
    
    func showMenu(){
        
        let notificationName = Notification.Name(Configuration.Notification.WillAppearMenu)
        NotificationCenter.default.post(name: notificationName, object: nil)
        
        rootWindow.rootViewController!.view.addSubview(seperatorView!)
        
        menuVC!.view.frame = CGRect(x:Configuration.Sizes.ScreenWidth, y:0, width:Configuration.Sizes.ScreenWidth, height:Configuration.Sizes.ScreenHeight)
        
        rootWindow.rootViewController!.view.addSubview(menuVC!.view)
        rootWindow.rootViewController!.addChildViewController(menuVC!)
        menuVC!.didMove(toParentViewController: rootWindow.rootViewController)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn , animations: {
            
            UIApplication.shared.statusBarStyle = .default
            self.menuVC?.view.frame = CGRect(x:0 , y:0, width:Configuration.Sizes.ScreenWidth, height:Configuration.Sizes.ScreenHeight)
            self.seperatorView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            }) { (finished) in
                
                let notificationName = Notification.Name(Configuration.Notification.DidAppearMenu)
                NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
    
    func hideMenu(){
        
        let notificationName = Notification.Name(Configuration.Notification.WillHideMenu)
        NotificationCenter.default.post(name: notificationName, object: nil)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut , animations: {
            
            UIApplication.shared.statusBarStyle = .default
            self.menuVC?.view.frame = CGRect(x:Configuration.Sizes.ScreenWidth, y:0, width: Configuration.Sizes.ScreenWidth, height: Configuration.Sizes.ScreenHeight)
            self.seperatorView?.backgroundColor = UIColor.clear
        }) { (finished) in
            
            self.menuVC!.willMove(toParentViewController: nil)
            self.menuVC?.view.removeFromSuperview()
            self.menuVC?.removeFromParentViewController()
            
            self.seperatorView?.removeFromSuperview()
            
            let notificationName = Notification.Name(Configuration.Notification.DidHideMenu)
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        
//        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut , animations: {
//            UIApplication.sharedApplication().statusBarStyle = .Default
//            self.menuVC!.view.frame = CGRectMake(Configuration.Sizes.ScreenWidth, 0, Configuration.Sizes.ScreenWidth, Configuration.Sizes.ScreenHeight)
//            //self.rootWindow.rootViewController?.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
//            self.seperatorView?.backgroundColor = UIColor.clearColor()
//            }) { (finished) in
//                self.menuVC!.willMoveToParentViewController(nil)
//                self.menuVC?.view.removeFromSuperview()
//                self.menuVC?.removeFromParentViewController()
//                
//                self.seperatorView?.removeFromSuperview()
//                
//                let notificationNameDidHideMenu = Notification.Name(Configuration.Notification.DidHideMenu)
//                NotificationCenter.default.post(name: notificationNameDidHideMenu, object: nil)
//        }
//        
//        UIView.animateWithDuration(0.9, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.1, options: .CurveEaseIn, animations: { () -> Void in
//            
//            
//        }) { (finished) -> Void in
//            
//            
//            
//        }
        
    }
    
    func setViewController(selectedViewController:UIViewController){
        
        hideMenu ()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
            // your function here
            self.rootWindow.rootViewController = selectedViewController
            self.rootWindow.makeKeyAndVisible()
        }
    }
    
    func presentViewController(selectedViewController:UIViewController){
        
        DispatchQueue.main.async {
            
            self.rootWindow.rootViewController?.present(selectedViewController, animated: true, completion: {
                self.hideMenu()
            })
        }
    }
}

