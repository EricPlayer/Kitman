//
//  LoginSignupViewController.swift
//  Swagafied
//
//  Created by Amitabha on 23/07/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit
import CoreText
import JSSAlertView

class LoginSignupViewController: BaseViewController,RTLabelDelegate {
    
    var logInCallBack : ((Bool)-> ())?
    var signUpCallBack : ((Bool)->())?
    var cancelActionCallBack : (()->())?
    
    var isChecked : Bool = false
    
    let signUpAPI =  SignUpAPI()
    let loginAPI = LoginAPI()
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var logInView: UIView!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var signUpTabButton: UIButton!
    @IBOutlet weak var loginTabButton: UIButton!
    
    @IBOutlet weak var termsAndConditionTextLabel: RTLabel!
    @IBOutlet weak var termsCheckBox: UIButton!
    
    @IBOutlet weak var signUpEmailField: UITextField!
    @IBOutlet weak var signUpUserNameField: UITextField!
    @IBOutlet weak var signUpPasswordField: UITextField!
    
    @IBOutlet weak var loginEmailField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    
    @IBOutlet weak var upperImageHeightConstraint: NSLayoutConstraint!
    
    internal var callBackrequired : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signUpButton.layer.borderColor = kWhiteColor.cgColor
        self.signUpButton.layer.borderWidth = kSinglePixelWidth
        
        self.logInButton.layer.borderColor = kWhiteColor.cgColor
        self.logInButton.layer.borderWidth = kSinglePixelWidth
        
        let text = "<font face=OpenSans-Bold size=10 color=#FFFFFF>I agree with the <a href=Terms style=text-decoration:none><i>Terms & Conditions</i></a> and <a href=Privacy><i> Privacy Policy</i></a></font>"
        termsAndConditionTextLabel.text = text
        termsAndConditionTextLabel.delegate = self
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Do any additional setup after loading the view.
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            
            upperImageHeightConstraint.constant = 180.0
        }else if UI_USER_INTERFACE_IDIOM() == .phone{
            
            if Configuration.Sizes.ScreenSize.height == 480 && UIScreen.main.scale == 2.0{
                upperImageHeightConstraint.constant = 180.0
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.loginTabButton.alpha = kDimmed
        logInView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonAction(_ sender: AnyObject) {
        
        if callBackrequired{
            cancelActionCallBack?()
        }
    }
    
    @IBAction func termsAndConditionCheckBoxAction(_ sender: AnyObject) {
        
        if !isChecked{
            termsCheckBox.setImage(UIImage(named: "checkBox_checked"), for: .normal)
        }else{
            termsCheckBox.setImage(UIImage(named: "checkBox"), for: .normal)
        }
        
        isChecked = !isChecked
        
    }
    
    
    @IBAction func signUpTabButtonAction(_ sender: AnyObject) {
        
        self.signUpTabButton.alpha = kEnabled
        self.loginTabButton.alpha = kDimmed
        
        logInView.isHidden = true
        signUpView.isHidden = false
        
    }
    
    @IBAction func loginTabButtonAction(_ sender: AnyObject) {
        
        self.signUpTabButton.alpha = kDimmed
        self.loginTabButton.alpha = kEnabled
        
        logInView.isHidden = false
        signUpView.isHidden = true
        
    }
    
    
    
    /**
     <#Description#>
     
     - parameter sender: <#sender description#>
     */
    @IBAction func loginAction(_ sender : AnyObject)  {
        
//        if callBackrequired{
//            NSUserDefaults.standardUserDefaults().setBool(true, forKey: Configuration.UserDefaultKeys.IsLoggedIn)
//            logInCallBack?(true)
//        }
        
        if callBackrequired{
            
            loginAPI.email = loginEmailField.text ?? ""
            loginAPI.password = loginPasswordField.text ?? ""
            
            if (Utility.isValidEmail(testStr: loginAPI.email) && loginAPI.password.characters.count >= 6){
                
                loginAPI.didCompleteRequest = { [weak self] success in
                    
                    if(success){
                        UserDefaults.standard.set(true, forKey: Configuration.UserDefaultKeys.IsLoggedIn)
                        
                        let updatelist = UpdatePortfolioWatchList()
                        updatelist.getPortfilioProductLists()
                        updatelist.getWatchListProductLists()
                        
                        updatelist.watchListCompletion = {
                            self!.logInCallBack?(true)
                        }
                        
                        
                    }else{
                        //self!.logInCallBack?(false)
                        JSSAlertView().danger(self!, title: "Error", text: "Login Failed")
                    }
                }
                
                let _ = NetworkManager.sharedManager.request(apiObject:loginAPI)
                
            }else{
                
                if(Utility.isValidEmail(testStr: signUpAPI.email) == false){
                    JSSAlertView().danger(self, title: "Error", text: "Invalid E-Mail ID")
                }else if (signUpAPI.password.characters.count < 6){
                    JSSAlertView().danger(self, title: "Error", text: "Password should be 6 char long")
                }
                
            }
        }
        
    }
    
    /**
     <#Description#>
     
     - parameter sender: <#sender description#>
     */
    @IBAction func signUpAction(_ sender : AnyObject)  {
        
        if callBackrequired{
            
            signUpAPI.email = signUpEmailField.text ?? ""
            signUpAPI.password = signUpPasswordField.text ?? ""
            
            if (signUpUserNameField.text?.characters.count)! < 5{
                
                let alert = UIAlertController(title: "Error", message: "User name must contain 6 character", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            if (Utility.isValidEmail(testStr: signUpAPI.email) && signUpAPI.password.characters.count >= 6 && isChecked){
                
                signUpAPI.didCompleteRequest = { [weak self] success in
                    
                    if(success){
                        
                        UserDefaults.standard.set(true, forKey: Configuration.UserDefaultKeys.IsLoggedIn)
                        self!.setValueForKey(value: self!.signUpEmailField.text! , key: "userEmailID")
                        self!.setValueForKey(value: self!.signUpUserNameField.text! , key: "userNameID")
                        
                        self!.signUpCallBack?(true)
                    }else{
                        self!.signUpCallBack?(false)
                    }
                }
                
                let _ = NetworkManager.sharedManager.request(apiObject:signUpAPI)
                
            }else{
                
                if(Utility.isValidEmail(testStr: signUpAPI.email) == false){
                    JSSAlertView().danger(self, title: "Error", text: "Invalid E-Mail ID")
                }else if (signUpAPI.password.characters.count < 6){
                    JSSAlertView().danger(self, title: "Error", text: "Password should be 6 char long")
                }else if (isChecked == false){
                    JSSAlertView().danger(self, title: "Error", text: "Agree to Terms and Conditions")
                }
                
            }
        }
    }
    
    func setValueForKey(value: String?, key: String){
    
        UserDefaults.standard.set(value ?? "", forKey: key)
        
    }
    
    //MARK:- RTLabel Delegate -
    
    func rtLabel(_ rtLabel: Any!, didSelectLinkWith url: URL!) {
        
        if url.absoluteString == "Terms"{
            
            // Show Terms and condition page
            let tcppVC : TCPPViewController =  loadViewControllerFromStroryboard(storyboard: Configuration.Storyboard.MainStoryBoard, viewControllerIndentifier:Configuration.ViewControllers.TCPPViewController) as! TCPPViewController
            tcppVC.pageType = .TermsAndCondition
            present(tcppVC, animated: true, completion: {
                
            })
            
        }else if url.absoluteString == "Privacy"{
            // show Privacy Policy Page
            
            let tcppVC : TCPPViewController =  loadViewControllerFromStroryboard(storyboard: Configuration.Storyboard.MainStoryBoard, viewControllerIndentifier:Configuration.ViewControllers.TCPPViewController) as! TCPPViewController
            
            tcppVC.pageType = .PrivacyPolicy
            present(tcppVC, animated: true, completion: {
                
            })
        }
        
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

class UpdatePortfolioWatchList {
    
    var dafaultUserID =  Utility.getUserID()
    let portfoliotListApiObject = ProtfolioListAPI()
    let watchlistListApiObject = WatchlistAPI()
    
    typealias Completion = ()->()
    var portfolioCompletion : Completion!
    var watchListCompletion : Completion!
    
    func getPortfilioProductLists(){
        
        portfoliotListApiObject.dafaultUserID = dafaultUserID
        portfoliotListApiObject.didCompleteRequest = { success in
            if(success){
                let list = self.portfoliotListApiObject.products
                self.updateDBForPortfolio(dataList: list)
            }
        }
        
        let _ = NetworkManager.sharedManager.request(apiObject:portfoliotListApiObject)
    }
    
    func getWatchListProductLists(){
        
        watchlistListApiObject.dafaultUserID = dafaultUserID
        watchlistListApiObject.didCompleteRequest = { success in
    
            if(success){
                let list = self.watchlistListApiObject.products
                self.updateDBForWatchlist(dataList: list)
            }
        }
        
        let _ = NetworkManager.sharedManager.request(apiObject:watchlistListApiObject)
    }
    
    func updateDBForWatchlist( dataList: [WatchlistObject] ){
        
        for data in dataList{
            
            let itemModel : ItemModel = ItemModel()
            itemModel.ItemId = data.productId!
            itemModel.ItemIsAddedToWatchList = true
            DatabaseHelper.sharedHelper.insertItem(item: itemModel)
            
        }
        
        watchListCompletion()
        
    }
    
    func updateDBForPortfolio( dataList: [Portfoliolist] ){
        
        for data in dataList{
            
            let itemModel : ItemModel = ItemModel()
            itemModel.ItemId = data.productId!
            itemModel.ItemIsAddedToPortfolio = true
            DatabaseHelper.sharedHelper.insertItem(item: itemModel)
            
        }
    }
    
}
