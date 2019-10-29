//
//  ProductRating.swift
//  Swagafied
//
//  Created by Amitabha on 05/09/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit

class ProductRating: UIView,ProductRatingDelegate {
    
    let editButton = UIButton()
    var delegate : ProductRatingDelegate!
    
    var totalRating : Int = 0{
        didSet{
            loadNumberOfStarts()
            loadStars()
            if editRating{
                showEditButton()
            }
        }willSet{
            self.removeAllSubViews()
        }
    }
    
    var editRating : Bool = false{
        didSet{
            if editRating == true{
                showEditButton()
            }else{
                hideEditButton()
            }
        }
    }
    
    var rating : Float = 0.0{
        didSet{
            loadStars()
            loadNumberOfStarts()
            if editRating{
                showEditButton()
            }
        }willSet{
            self.removeAllSubViews()
        }
    }
    
    
    
    let viewSize : CGSize = CGSize(width: Configuration.Sizes.ScreenWidth/3, height: 50)
    let starViewSize : CGSize = CGSize(width: (Configuration.Sizes.ScreenWidth/3 - (Configuration.Sizes.ScreenWidth*0.065 + 10))/5, height: (Configuration.Sizes.ScreenWidth/3 - (Configuration.Sizes.ScreenWidth*0.065 + 10))/5)
    
    let productRatingEditorView : ProductRatingEditor = ProductRatingEditor()
    // MARK: - Initialization
    
     init(){
        super.init(frame: CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height))
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x:0, y:0, width: viewSize.width, height: viewSize.height))
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func awakeFromNib(){
        super.awakeFromNib()
        setupUI()
        
    }
    
    private func setupUI(){
        
        self.backgroundColor = Configuration.NavigationBar.NavigationBarBackgroundColor
        
        // App Icon
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProductRating.enableEditMode))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        //self.addGestureRecognizer(tapGesture)
    }
    
    private func loadStars(){
        
        for var i in 0...4{
            
            let starView = UIImageView()
            let cgfloat = CGFloat(i)
            starView.frame = CGRect( x: cgfloat * starViewSize.width, y: 0, width: starViewSize.width, height: starViewSize.height)
            starView.image = getImageForIndex(index: i)
            self.addSubview(starView)
            
        }
        
    }
    
    private func loadNumberOfStarts(){
        
        let totalStars = UILabel()
        totalStars.text = "\(totalRating) Product Ratings"
        totalStars.adjustsFontSizeToFitWidth = true
        totalStars.font = UIFont.systemFont(ofSize: 13)
        totalStars.frame = CGRect( x: 0, y: starViewSize.width , width: viewSize.width, height: viewSize.height - starViewSize.height)
        self.addSubview(totalStars)
        
    }
    
    private func showEditButton(){
        
        editButton.frame = CGRect(x: viewSize.width - Configuration.Sizes.ScreenWidth*0.065 , y: 0, width: Configuration.Sizes.ScreenWidth*0.065, height: Configuration.Sizes.ScreenWidth*0.065)
        editButton.setImage(UIImage(named: "black-review"), for: .normal)
        editButton.addTarget(self, action: #selector(self.enableEditMode(sender:)), for: .touchUpInside)
        self.addSubview(editButton)
        self.bringSubview(toFront: editButton)
        
    }
    
    private func hideEditButton(){
        editButton.isUserInteractionEnabled = false
    }
    
    @objc func enableEditMode(sender : UIButton){
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let viewController = appDelegate.window!.rootViewController
        
        let extendedProductRatingEditorView = UIButton()
        extendedProductRatingEditorView.frame = CGRect(x: 0, y: 0, width: Configuration.Sizes.ScreenWidth, height : Configuration.Sizes.ScreenHeight)
        extendedProductRatingEditorView.addTarget(self, action: #selector(self.hideProductRatingEditorView(sender:)), for: .touchUpInside)
        
         viewController?.view.addSubview(extendedProductRatingEditorView)
        
        productRatingEditorView.frame = CGRect(x: 0, y: Configuration.Sizes.ScreenHeight-100 , width: Configuration.Sizes.ScreenWidth, height: 100)
        productRatingEditorView.rating = 0
        viewController?.view.addSubview(productRatingEditorView)
        productRatingEditorView.delegate = self
        
    }
    
    @objc func hideProductRatingEditorView(sender : UIButton){
        sender.removeFromSuperview()
        productRatingEditorView.removeFromSuperview()
    }
    
    private func getImageForIndex(index : Int) -> UIImage{
        
        let floorValue = floor(rating)
        
        if (index < Int(floorValue)){
            return UIImage(named: "orange-star")!
        }else{
            if (index == Int(floorValue) ){
                
                let deltaValue = rating - floorValue
                
                if deltaValue < 0.3{
                    return UIImage(named: "grey-star")!
                }else if (deltaValue >= 0.3 && deltaValue <= 0.7){
                    return UIImage(named: "Half-star")!
                }else{
                    return UIImage(named: "orange-star")!
                }
            }else{
                return UIImage(named: "grey-star")!
            }
        }
        
    }
    
    func didSelectCancelButton(){
        self.delegate.didSelectCancelButton()
    }
    
    func didSelectRatingOptionWithRating(rating: Int){
        self.isUserInteractionEnabled = false
        self.delegate.didSelectRatingOptionWithRating(rating: rating)
        editRating = false
    }

}

extension UIView {
    /**
     Remove allSubView in view
     */
    func removeAllSubViews() {
        let  _ = self.subviews.map({ $0.removeFromSuperview() })
    }
    
}


class ProductRatingEditor: UIView {
    
    var delegate : ProductRatingDelegate!
    var rating : Float = 0.0{
        didSet{
            loadStars()
        }willSet{
            removeStars()
        }
    }

    let viewSize : CGSize = CGSize( width : Configuration.Sizes.ScreenWidth, height: 100)
    let starViewSize : CGSize = CGSize(width : 45, height:  45)
    
    // MARK: - Initialization
    
    init(){
        super.init(frame: CGRect(x: 0,y: 0,width: viewSize.width,  height: viewSize.height))
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0,y: 0, width: viewSize.width, height: viewSize.height))
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func awakeFromNib(){
        super.awakeFromNib()
        setupUI()
        
    }
    
    private func setupUI(){
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let horizontlLine = UILabel()
        horizontlLine.frame = CGRect(x: 0, y: 60, width: viewSize.width, height: 1)
        horizontlLine.backgroundColor = UIColor.white
        self.addSubview(horizontlLine)
        
        let verticalLine = UILabel()
        verticalLine.frame = CGRect(x: viewSize.width/2, y: 60, width: 1, height: 40)
        verticalLine.backgroundColor = UIColor.white
        self.addSubview(verticalLine)
        
        loadStars()
        loadButtons()
    }
    
    private func loadStars(){
        
        for var i in 0...4{
            
            let starView = UIButton()
            starView.tag = 100+i
            let cgfloat = CGFloat(i)
            starView.frame = CGRect(x: (viewSize.width - (starViewSize.width*5))/2 + cgfloat * starViewSize.width, y: 8, width: starViewSize.width,height: starViewSize.height)
            starView.addTarget(self, action: #selector(ProductRatingEditor.countRating(sender:)), for: .touchUpInside)
            starView.setImage(getImageForIndex(index: i), for: .normal)
            self.addSubview(starView)
        }
        
    }
    
    private func loadButtons(){
        
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x:0, y:60, width: viewSize.width/2,height: 40)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(ProductRatingEditor.cancelButtonAction(sender:)), for: .touchUpInside)
        
        let doneButton = UIButton()
        doneButton.frame = CGRect(x:viewSize.width/2, y:60,width: viewSize.width/2,height: 40)
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.addTarget(self, action: #selector(ProductRatingEditor.doneButtonAction(sender:)), for: .touchUpInside)
        
        self.addSubview(cancelButton)
        self.addSubview(doneButton)
    }
    
    @objc private func countRating(sender : UIButton){
        rating = Float(sender.tag-99)
    }
    
    @objc private func cancelButtonAction(sender : UIButton){
        removeStars()
        self.removeFromSuperview()
        self.delegate.didSelectCancelButton()
    }
    
    @objc private func doneButtonAction(sender : UIButton){
        
        /*
            Call Product rating API
        */
        loginCallBackAction(success: {
            
            self.removeStars()
            self.removeFromSuperview()
            self.delegate.didSelectRatingOptionWithRating(rating: Int(self.rating))
            
            }) { 
                
                // Login Failure
                
        }
        
        
    }
    
    private func removeStars(){
        
        for var view in self.subviews{
            if view.tag >= 100 && view.tag <= 104{
                view.removeFromSuperview()
            }
        }
    }

    private func getImageForIndex(index : Int) -> UIImage{
        
        let floorValue = floor(rating)
        
        if (index < Int(floorValue)){
            return UIImage(named: "orange-star")!
        }else{
            if (index == Int(floorValue) ){
                
                let deltaValue = rating - floorValue
                
                if deltaValue < 0.3{
                    return UIImage(named: "grey-star")!
                }else if (deltaValue >= 0.3 && deltaValue <= 0.7){
                    return UIImage(named: "Half-star")!
                }else{
                    return UIImage(named: "orange-star")!
                }
            }else{
                return UIImage(named: "grey-star")!
            }
        }
    }
    
    func loginCallBackAction(success:@escaping ()->Void, failure:@escaping ()->()){
        
        if !UserDefaults.standard.bool(forKey: Configuration.UserDefaultKeys.IsLoggedIn){
            
            // Get login signup view controller
            let loginSignupVC : LoginSignupViewController = loadViewControllerFromStroryboard(storyboard: Configuration.Storyboard.MainStoryBoard, viewControllerIndentifier: Configuration.ViewControllers.LoginSignupViewController) as! LoginSignupViewController
            loginSignupVC.callBackrequired = true
            
            let appDelegate  = UIApplication.shared.delegate as! AppDelegate
            let viewController = appDelegate.window!.rootViewController
            // Present login signup view controller
            viewController!.present(loginSignupVC, animated: true, completion: {
             
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
    
    func loadViewControllerFromStroryboard(storyboard:String, viewControllerIndentifier: String) -> UIViewController{
        let storyBoard : UIStoryboard = UIStoryboard(name: storyboard, bundle: nil)
        let viewController : UIViewController = storyBoard.instantiateViewController(withIdentifier: viewControllerIndentifier)
        
        return viewController
    }
}
