//
//  RightMenuViewController.swift
//  Swagafied
//
//  Created by Amitabha on 15/10/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit

class RightMenuViewController: BaseViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    var productList : ProductListViewController!
    var editProfile : EditProfileViewController!
    var tcppVC : TCPPViewController!
    var porifolioVC: PortfolioListViewController!
    var watchlistVC: WatchListViewController!
    var timelineVC: TimeLineViewController!
    var editPassword: EditPasswordViewController!
    
    var loginLogout: String{
        get{
            
            if ( UserDefaults.standard.bool(forKey: Configuration.UserDefaultKeys.IsLoggedIn) == false ){
                return "Log In"
            }else{
                return "Log Out"
            }
            
        }
    }
    
    let headerNames:Array<String> = ["Search Tool","Profile Tools","Account Tools"]
    var dataSource:Array<Array<String>> = [["Show Me Some Kicks"],["Timeline", "My Portfolio", "My Watchlist", "Message Center"],["Notifications","Edit Profile","Edit Password","Terms Of Use","Privacy Policy","loginLogout"]]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        productList = loadViewControllerFromStroryboard(storyboard: Configuration.Storyboard.MainStoryBoard, viewControllerIndentifier: Configuration.ViewControllers.ProductListViewController) as! ProductListViewController
        
         editProfile = loadViewControllerFromStroryboard(storyboard: Configuration.Storyboard.MainStoryBoard, viewControllerIndentifier: Configuration.ViewControllers.EditProfileViewController) as! EditProfileViewController
        
        tcppVC =  loadViewControllerFromStroryboard(storyboard: Configuration.Storyboard.MainStoryBoard, viewControllerIndentifier:Configuration.ViewControllers.TCPPViewController) as! TCPPViewController
        
        porifolioVC = loadViewControllerFromStroryboard(storyboard: Configuration.Storyboard.MainStoryBoard, viewControllerIndentifier: Configuration.ViewControllers.PortfolioListViewController) as! PortfolioListViewController
        
        watchlistVC = loadViewControllerFromStroryboard(storyboard: Configuration.Storyboard.MainStoryBoard, viewControllerIndentifier: Configuration.ViewControllers.WatchListViewController) as! WatchListViewController
        
        timelineVC = loadViewControllerFromStroryboard(storyboard: Configuration.Storyboard.MainStoryBoard, viewControllerIndentifier:Configuration.ViewControllers.TimeLineViewController) as! TimeLineViewController
        
        editPassword = loadViewControllerFromStroryboard(storyboard: Configuration.Storyboard.MainStoryBoard, viewControllerIndentifier:Configuration.ViewControllers.EditPasswordViewController) as! EditPasswordViewController
        
        // Add like button to navigation bar as left item
        let likeButton = UIButton()
        likeButton.setImage(UIImage(named: "back"), for: .normal)
        self.navigationBar.addLeftBarButton(leftButton: likeButton)
        
        self.shadowImageView.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        tableview.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.setNavigationView()
        }
    }
    
    func setNavigationView(){
        self.view.bringSubview(toFront: self.navigationBar)
        self.view.bringSubview(toFront: self.shadowImageView)
    }
    
    //MARK:- Navigatin Bar Delegate -
    override func didSelectLeftButton(sender:UIButton) {
       WindowManager.sharedManager.hideMenu()
    }
    
    override func didSelectRightButton(sender:UIButton) {

    }

}

// MARK: - TableView Delegate -
extension RightMenuViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        /*
         progressHud =  MBProgressHUD.showHUDAddedTo(self.view, animated: true)
         progressHud!.labelText =  "Downloading..."
         progressHud!.mode = .Indeterminate
         */
        //performSegueWithIdentifier(Configuration.SegueNames.ShowProductDetailViewController, sender: self)
        
        switch indexPath.section {
            
            case 0:
                let navc = UINavigationController(rootViewController: productList)
                navc.setNavigationBarHidden(true, animated: false)
                setViewController(viewController: navc)
                //setViewController(productList)
                break
            
            case 1:
            
                switch indexPath.row {
                case 0:
                    
                    // Show Alert View
                    self.showAlertView(title: "Whoops!", message: "You'll have to Login or Signup to access this page.", cancelButtonTitle: "Cancel", okButtonTitle: "Ok")
                    
                    // Alert action hndler
                    self.okAlertAction = {
                        ()->() in
                        
                        self.loginCallBackAction(success: {
                            () -> () in
                            
                            let navc = UINavigationController(rootViewController: self.timelineVC)
                            navc.setNavigationBarHidden(true, animated: false)
                            self.setViewController(viewController: navc)
                            
                        }, failure: {() -> () in
                            
                        })
                        
                    }
                    
                    break
                    
                case 1:
                    
                    // Show Alert View
                    self.showAlertView(title: "Whoops!", message: "You'll have to Login or Signup to access this page.", cancelButtonTitle: "Cancel", okButtonTitle: "Ok")
                    
                    // Alert action hndler
                    self.okAlertAction = {
                        ()->() in
                        
                        self.loginCallBackAction(success: {
                            () -> () in
                            
                            let navc = UINavigationController(rootViewController: self.porifolioVC)
                            navc.setNavigationBarHidden(true, animated: false)
                            self.setViewController(viewController: navc)
                            
                        }, failure: {() -> () in
                            
                        })
                    }
                    
                    break
                case 2:
                    
                    // Show Alert View
                    self.showAlertView(title: "Whoops!", message: "You'll have to Login or Signup to access this page.", cancelButtonTitle: "Cancel", okButtonTitle: "Ok")
                    
                    // Alert action hndler
                    self.okAlertAction = {
                        ()->() in
                        
                        self.loginCallBackAction(success: {
                            () -> () in
                            
                            let navc = UINavigationController(rootViewController: self.watchlistVC)
                            navc.setNavigationBarHidden(true, animated: false)
                            self.setViewController(viewController: navc)
                            
                        }, failure: {() -> () in
                            
                        })
                    }
                    
                    break
                case 3:
                    break
                default:
                    break
                }
                
                break
            
            case 2:
                
                switch indexPath.row {
                    
                    case 0:
                        break
                    case 1:
                        
                        // Show Alert View
                        self.showAlertView(title: "Whoops!", message: "You'll have to Login or Signup to access this page.", cancelButtonTitle: "Cancel", okButtonTitle: "Ok")
                        
                        // Alert action hndler
                        self.okAlertAction = {
                            ()->() in
                            
                            self.loginCallBackAction(success: {
                                () -> () in
                                
                                self.presentViewController(viewController: self.editProfile)
                                
                            }, failure: {() -> () in
                            
                            })
                        }
                        
                        break
                    case 2:
//                        let navc = UINavigationController(rootViewController: editPassword)
//                        navc.setNavigationBarHidden(true, animated: false)
//                        setViewController(navc)
                        break
                    case 3:
                        tcppVC.pageType = .TermsAndCondition
                        let navc = UINavigationController(rootViewController: tcppVC)
                        navc.setNavigationBarHidden(true, animated: false)
                        self.setViewController(viewController: navc)
                        break
                    case 4:
                        tcppVC.pageType = .PrivacyPolicy
                        let navc = UINavigationController(rootViewController: tcppVC)
                        navc.setNavigationBarHidden(true, animated: false)
                        self.setViewController(viewController: navc)
                        break
                    case 5:
                        
                        if (loginLogout == "Log In") {
                            
                            self.loginCallBackAction(success: {
                                () -> () in
                                tableView.reloadData()
                                
                                let notificationName = Notification.Name(Configuration.Notification.LogInSuccessful)
                                NotificationCenter.default.post(name: notificationName, object: nil)
                                
                                let navc = UINavigationController(rootViewController: self.productList)
                                navc.setNavigationBarHidden(true, animated: false)
                                self.setViewController(viewController: navc)
                                
                            }, failure: {() -> () in
                                
                            })
                            
                        }else{
                            
                            User.sharedUser.clearData()
                            Utility.removeUserData()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                                let alert = UIAlertController(title: "Logout", message: "Successfully logged out", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                tableView.reloadData()
                                
                                let notificationName = Notification.Name(Configuration.Notification.LogOutSuccessful)
                                NotificationCenter.default.post(name: notificationName, object: nil)
                                
                            }
                            
                        }
                        
                        break
                    default:
                        break
                }
                
                break
            
            default:
                break
        }
    }
    
    func setViewController(viewController : UIViewController){
        WindowManager.sharedManager.setViewController(selectedViewController: viewController)
    }
    
    func presentViewController(viewController : UIViewController){
        WindowManager.sharedManager.presentViewController(selectedViewController: viewController)
    }
}

// MARK: - TableView DataSource -
extension RightMenuViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((dataSource[section]).count)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: Configuration.CellIdentifier.MenuCell, for: indexPath)
        
        if dataSource[indexPath.section][indexPath.row] == "loginLogout"{
            cell.textLabel?.text = "  "+loginLogout
            cell.selectionStyle = .none
            
        }else{
            cell.textLabel?.text = "  "+dataSource[indexPath.section][indexPath.row]
            cell.selectionStyle = .none
        }
    
        if indexPath.row == 3 && indexPath.section == 1{
            cell.textLabel?.textColor = UIColor.gray
        }
        
        if indexPath.row == 0 && indexPath.section == 2{
            cell.textLabel?.textColor = UIColor.gray
        }
        if indexPath.row == 2 && indexPath.section == 2{
            cell.textLabel?.textColor = UIColor.gray
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0{
//            return 0
//        }else{
//            return 50.0
//        }
//
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "  "+headerNames[section]
    }
    

//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        
//    }
//    
//    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//       
//    }
}

