//
//  ProductDetailViewController.swift
//  Swagafied
//
//  Created by Amitabha on 21/07/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit
import MBProgressHUD
import JSSAlertView

class ProductDetailViewController: BaseViewController,ProductRatingDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var shoeSizePicker : ShoeSizePicker!
    var dataModel : ProductObject?
    var watchListButton : UIButton!
    let imagePicker = UIImagePickerController()
    let likeProductAPIObject = LikeProductAPI()
    let productRatingAPIObject = ProductRatingAPI()
    let unlikeProductAPIObject = UnlikeProductAPI()
    let portfolioAdd = AddToPortfolio()
    let portfolioDelete = RemoveFromPortfolio()
    let watchlistAdd = AddToWatchlist()
    let watchlistDelete = RemoveFromWatchlist()

    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var pageIndicator: UIPageControl!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var sellYoursButton: UIButton!
    
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var sellerLabel: UILabel!
    @IBOutlet weak var sharedPicLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var sharesButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var portfolioButton: UIButton!
    @IBOutlet weak var sellersButton: UIButton!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    var productRatingView : ProductRating!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
        self.sellYoursButton.layer.borderColor = kOrangeColor.cgColor;
        
        // Add like button to navigation bar as left item
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "Back-Arrow"), for: .normal)
        self.navigationBar.addLeftBarButton(leftButton: backButton)
        
        // Add like button to navigation bar as right item
        let menuButton = UIButton()
        menuButton.setImage(UIImage(named: "Menu-Icon"), for: .normal)
        
        watchListButton = UIButton()
        watchListButton.setImage(UIImage(named: "Watchlist-Off-Icon"), for: .normal)
        
        self.navigationBar.addRightBarButtons(rightButtons: [watchListButton,menuButton])
        
        productImageView.isUserInteractionEnabled = true
//        let rightSwipe : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ProductDetailViewController.swipeActionOnImage(sender:)))
//        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
//        productImageView.addGestureRecognizer(rightSwipe)
//        
//        let leftSwipe : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ProductDetailViewController.swipeActionOnImage(sender:)))
//        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
//        productImageView.addGestureRecognizer(leftSwipe)
        
        mainScrollView.canCancelContentTouches = false
        mainScrollView.delaysContentTouches = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.setRatingView()
        }
    }
    
    func setRatingView(){
        
        productRatingView = ProductRating()
        productRatingView.delegate = self
        productRatingView.isUserInteractionEnabled = true
        productRatingView.rating = (dataModel?.productRating)!
        productRatingView.totalRating = (dataModel?.totalRating)!
        productRatingView.editRating = !(self.dataModel?.userRated)!
        mainScrollView.addSubview(productRatingView)
        
        productRatingView.autoPinEdge(.leading, to: .leading, of: self.view, withOffset: 20)
        productRatingView.autoPinEdge(.top, to: .bottom, of: productImageView, withOffset: 30)
        productRatingView.autoSetDimension(.height, toSize: 50)
        productRatingView.autoSetDimension(.width, toSize: 165)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        mainScrollView.isScrollEnabled = false
        if let dataModel = self.dataModel{
            
            self.productImageView.image = dataModel.productMainImage
            self.productNameLabel.text = dataModel.productName
            
            if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: (self.dataModel?.id)!){
                if productInfo.isMessaged!.boolValue{
                    self.commentButton.setImage(UIImage(named: "green-comment"), for: .normal)
                }
            }
            
            if self.dataModel?.isLiked == true {
                self.likeButton.setImage(UIImage(named: "like-dashboard-selected"), for: .normal)
            }
            
            if self.dataModel?.isShared == true{
                self.sharesButton.setImage(UIImage(named: "share-dashboard-selected"), for: .normal)
            }
            
            if self.dataModel?.isAddedToPortfolio == true{
                self.portfolioButton.setImage(UIImage(named: "Dashboard-Portfolio-Icon-Orange"), for: .normal)
            }
            
            if self.dataModel?.isAddedToWatchList == true{
                watchListButton.setImage(UIImage(named: "Watchlist-On-Icon"), for: .normal)
            }
            
            productDescriptionLabel.adjustsFontSizeToFitWidth = true
            
            let arr = dataModel.productCollection.components(separatedBy: ",")
            var collectionName = ""
            if arr.count >= 2{
                if arr[1].characters.count > 1{
                    collectionName = "Multiple"
                }else{
                    collectionName = arr.first!
                }
            }else{
                collectionName = "Not Found"
            }
            
            
            if let date  = DateTimeFormatter.sharedFormatter.convertStringToDate(dateString: dataModel.productReleaseDate!) {
                self.productDescriptionLabel.text = "  Collection: \(collectionName)   Released: \(date.year())    Retail: $\(dataModel.retailPrice!)  "
                self.productDescriptionLabel.sizeToFit()
            }else{
                self.productDescriptionLabel.text = "  Collection: \(collectionName)    Released:     Retail: $\(dataModel.retailPrice!)  "
                self.productDescriptionLabel.sizeToFit()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func swipeActionOnImage(_ sender : UISwipeGestureRecognizer){
        
        if sender.direction == .right{
            print("right")
        }else if sender.direction == .left{
            print("left")
        }
        
    }
    
    @IBAction func sellYoursButtonAction(_ sender: AnyObject) {
        
        // Show Alert View
        self.showAlertView(title: "Whoops!", message: "You'll have to Login or Signup to access this page.", cancelButtonTitle: "Cancel", okButtonTitle: "Ok")
        
        // Alert action hndler
        self.okAlertAction = {
            ()->() in
          
            self.loginCallBackAction(success: {
                
                // Success Block
                ()->() in
                
                let sellerYoursVC : SellYoursNowViewController = self.loadViewControllerFromStroryboard(storyboard: Configuration.Storyboard.MainStoryBoard, viewControllerIndentifier: Configuration.ViewControllers.SellYoursNowViewController) as! SellYoursNowViewController
                sellerYoursVC.dataModel = self.dataModel
                self.navigationController?.pushViewController(sellerYoursVC, animated: true)
                
            }, failure: {
                
                // Failure Block
                ()->() in
                
            })
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- IBAction Methods -
    
    @IBAction func tagsButtonAction(_ sender: AnyObject) {
        
        // Show Alert View
        self.showAlertView(title: "Whoops!", message: "You'll have to Login or Signup to access this page.", cancelButtonTitle: "Cancel", okButtonTitle: "Ok")
        
        // Alert action hndler
        self.okAlertAction = {
            ()->() in
          
            self.loginCallBackAction(
                success: {
                    // Success Call Back
                    () -> () in
                    
                    self.likeProductAPIObject.didCompleteRequest = { [weak self] success in
                        MBProgressHUD.hide(for: self!.view, animated: true)
                        if(success){
                            self!.likeButton.setImage(UIImage(named: "like-dashboard-selected"), for: .normal)
                            self!.dataModel!.productLiked(isLiked: true)
                            self?.updateDataBaseWithTagInfo(liked: true)
                        }else{
                            
                        }
                    }
                    
                    self.unlikeProductAPIObject.didCompleteRequest = { [weak self] success in
                        MBProgressHUD.hide(for: self!.view, animated: true)
                        if(success){
                            self!.likeButton.setImage(UIImage(named: "black-tag"), for: .normal)
                            self!.dataModel!.productLiked(isLiked: false)
                            self?.updateDataBaseWithTagInfo(liked: false)
                        }else{
                            
                        }
                    }
                    
                    if self.dataModel?.isLiked == true {
                        let _ = NetworkManager.sharedManager.request(apiObject:self.unlikeProductAPIObject)
                    }else{
                        let _ = NetworkManager.sharedManager.request(apiObject:self.likeProductAPIObject)
                    }
                    
            } ,failure : {
                // Failure Call Back
                ()->() in
                
            })
            
        }
    }
    
    @IBAction func sellersButtonAction(_ sender: AnyObject) {
        
        let sellerVC : SellerViewController = loadViewControllerFromStroryboard(storyboard: Configuration.Storyboard.MainStoryBoard, viewControllerIndentifier: Configuration.ViewControllers.SellerViewController) as! SellerViewController
        sellerVC.dataModel = self.dataModel
        self.navigationController?.pushViewController(sellerVC, animated: true)
        
    }
    
    @IBAction func portfolioButtonAction(_ sender: AnyObject) {
        
        // Show Alert View
        self.showAlertView(title: "Whoops!", message: "You'll have to Login or Signup to access this page.", cancelButtonTitle: "Cancel", okButtonTitle: "Ok")
        
        // Alert action hndler
        self.okAlertAction = {
            ()->() in
            
            self.loginCallBackAction(
                success: {
                    // Success Call Back
                    () -> () in
                    
                    let productObject : ProductObject = self.dataModel!
                    
                    if productObject.isAddedToPortfolio == false{
                        
                        self.shoeSizePicker = ShoeSizePicker()
                        self.view.addSubview(self.shoeSizePicker)
                        
                        self.shoeSizePicker.autoPinEdge(.top, to: .top, of: self.view)
                        self.shoeSizePicker.autoPinEdge(.trailing, to: .trailing, of: self.view)
                        self.shoeSizePicker.autoPinEdge(.leading, to: .leading, of: self.view)
                        self.shoeSizePicker.autoPinEdge(.bottom, to: .bottom, of: self.view)
                        
                        self.shoeSizePicker.cancelActionCompletionHandler = {
                            ()->() in
                            
                        }
                        
                        self.shoeSizePicker.selectActionCompletionHandler = {
                            (selectedID,size,price) -> () in
                            
                            print("\(selectedID) - \(price)")
                            MBProgressHUD.showAdded(to: self.view, animated: true)
                            
                            self.portfolioAdd.productID = productObject.id
                            self.portfolioAdd.productSize = selectedID
                            self.portfolioAdd.productPrice = price
                            self.portfolioAdd.didCompleteRequest = { [weak self] success in
                                
                                MBProgressHUD.hide(for: self!.view, animated: true)
                                if(success){
                                    
                                    self!.portfolioButton.setImage(UIImage(named: "Dashboard-Portfolio-Icon-Orange"), for: .normal)
                                    productObject.addToPortfolio(isAdded: true)
                                    
                                    if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: productObject.id){
                                        
                                        let itemModel  = ItemModel(product: productInfo)
                                        itemModel.ItemIsAddedToPortfolio = true
                                        DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                                        
                                    }else{
                                        
                                        let itemModel : ItemModel = ItemModel()
                                        itemModel.ItemId = productObject.id
                                        itemModel.ItemIsAddedToPortfolio = true
                                        DatabaseHelper.sharedHelper.insertItem(item: itemModel)
                                        
                                    }
                                    
                                }else{
                                    
                                }
                            }
                            
                            let _ = NetworkManager.sharedManager.request(apiObject:self.portfolioAdd)
                        }
                        
                    }else{
                        
                        self.portfolioDelete.portfolioID = productObject.id
                        self.portfolioDelete.didCompleteRequest = { [weak self] success in
                            
                            MBProgressHUD.hide(for: self!.view, animated: true)
                            if(success){
                                self!.portfolioButton.setImage(UIImage(named: "Dashboard-Portfolio-Icon"), for: .normal)
                                productObject.addToPortfolio(isAdded: false)
                                
                                if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: productObject.id){
                                    
                                    let itemModel  = ItemModel(product: productInfo)
                                    itemModel.ItemIsAddedToPortfolio = false
                                    DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                                    
                                }else{
                                    
                                    let itemModel : ItemModel = ItemModel()
                                    itemModel.ItemId = productObject.id
                                    itemModel.ItemIsAddedToPortfolio = false
                                    DatabaseHelper.sharedHelper.insertItem(item: itemModel)
                                    
                                }
                                
                            }else{
                                
                            }
                        }
                        
                        let _ = NetworkManager.sharedManager.request(apiObject:self.portfolioDelete)
                        
                    }
                    
            } ,failure : {
                // Failure Call Back
                ()->() in
                
            })
        }
    }
    
    @IBAction func commentsButtonAction(_ sender: AnyObject) {
        
        // Show Alert View
        self.showAlertView(title: "Whoops!", message: "You'll have to Login or Signup to access this page.", cancelButtonTitle: "Cancel", okButtonTitle: "Ok")
        
        // Alert action hndler
        self.okAlertAction = {
            ()->() in
            
            self.loginCallBackAction(
                success: {
                    // Success Call Back
                    () -> () in
                    
                    let messageVC : MessagesViewController = self.loadViewControllerFromStroryboard(storyboard: Configuration.Storyboard.MainStoryBoard, viewControllerIndentifier: Configuration.StoryboardVC.MessagesViewController) as! MessagesViewController
                    messageVC.dataModel = self.dataModel
                    self.navigationController?.pushViewController(messageVC, animated: true)
                    
            } ,failure : {
                // Failure Call Back
                ()->() in
                
            })
            
        }
    }
    
    @IBAction func sharesButtonAction(_ sender: AnyObject) {
        
        // Show Alert View
        self.showAlertView(title: "Whoops!", message: "You'll have to Login or Signup to access this page.", cancelButtonTitle: "Cancel", okButtonTitle: "Ok")
        
        // Alert action hndler
        self.okAlertAction = {
            ()->() in
            
            self.loginCallBackAction(
                success: {
                    // Success Call Back
                    () -> () in
                    
                    if self.dataModel?.isShared == false{
                        let text = "Find Lit Kicks @Swagafied. Download the app"
                        if let image = self.dataModel!.productMainImage {
                            
                            let vc = UIActivityViewController(activityItems: [image,text], applicationActivities: [])
                            self.present(vc, animated: true, completion: nil)
                            
                            //String?, Bool, [AnyObject]?, NSError?
                            vc.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
                                
                                if error == nil && completed{
                                    
                                    // Call Share API here
                                    
                                    self.sharesButton.setImage(UIImage(named: "share-dashboard-selected"), for: .normal)
                                    
                                    if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: (self.dataModel?.id)!){
                                        
                                        let itemModel  = ItemModel(product: productInfo)
                                        itemModel.ItemIsShared = true
                                        DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                                        
                                    }else{
                                        
                                        let itemModel : ItemModel = ItemModel()
                                        itemModel.ItemId = (self.dataModel?.id)!
                                        itemModel.ItemIsShared = true
                                        DatabaseHelper.sharedHelper.insertItem(item: itemModel)
                                        
                                    }
                                }
                                    
                                else{
                                    
                                }
                            }
                        }else{
                            // Image not found
                            JSSAlertView().danger((sharedAppDelegate.window?.rootViewController)!, title: "Error", text: "Image Not Found")
                        }
                    }
                    
            } ,failure : {
                // Failure Call Back
                ()->() in
                
            })
            
        }
    }
    
    func updateDataBaseWithTagInfo(liked : Bool){
        
        if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: (dataModel?.id)!){
            
            let itemModel  = ItemModel(product: productInfo)
            itemModel.ItemIsLiked = liked
            DatabaseHelper.sharedHelper.updateItem(item: itemModel)
            
        }else{
            
            let itemModel : ItemModel = ItemModel()
            itemModel.ItemId = (dataModel?.id)!
            itemModel.ItemIsLiked = true
            DatabaseHelper.sharedHelper.insertItem(item: itemModel)
            
        }
        
    }
    
    
    //MARK:- ImagePicker controller delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
            
        }
        dismiss(animated: true, completion: nil)

    }
    
    //MARK:- Navigatin Bar Delegate -

    override func didSelectLeftButton(sender:UIButton) {
       let _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didSelectRightButton(sender:UIButton) {
        
        switch sender.tag {
        case 0:
            toggleWatchList(sender: sender)
            break
        case 1:
            WindowManager.sharedManager.showMenu()
            break
            
        default:
            break
        }
    }
    
    func toggleWatchList(sender: UIButton){
        // Show Alert View
        self.showAlertView(title: "Whoops!", message: "You'll have to Login or Signup to access this page.", cancelButtonTitle: "Cancel", okButtonTitle: "Ok")
        
        // Alert action hndler
        self.okAlertAction = {
            ()->() in
            
            self.loginCallBackAction(
                success: {
                    // Success Call Back
                    () -> () in
                    
                    let productObject : ProductObject = self.dataModel!
                    
                    if productObject.isAddedToWatchList == false{
                        
                        self.shoeSizePicker = ShoeSizePicker()
                        self.view.addSubview(self.shoeSizePicker)
                        
                        self.shoeSizePicker.autoPinEdge(.top, to: .top, of: self.view)
                        self.shoeSizePicker.autoPinEdge(.trailing, to: .trailing, of: self.view)
                        self.shoeSizePicker.autoPinEdge(.leading, to: .leading, of: self.view)
                        self.shoeSizePicker.autoPinEdge(.bottom, to: .bottom, of: self.view)
                        
                        self.shoeSizePicker.cancelActionCompletionHandler = {
                            ()->() in
                            
                        }
                        
                        self.shoeSizePicker.selectActionCompletionHandler = {
                            (selectedID,size,price) -> () in
                            

                            MBProgressHUD.showAdded(to: self.view, animated: true)
                            
                            self.watchlistAdd.productID = productObject.id
                            self.watchlistAdd.productSize = selectedID
                            self.watchlistAdd.productPrice = price
                            self.watchlistAdd.didCompleteRequest = { [weak self] success in
                                
                                MBProgressHUD.hide(for: self!.view, animated: true)
                                if(success){
                                    
                                    sender.setImage(UIImage(named: "Watchlist-On-Icon"), for: .normal)
                                    productObject.addToWatchList(isAdded: true)
                                    
                                    if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: productObject.id){
                                        
                                        let itemModel  = ItemModel(product: productInfo)
                                        itemModel.ItemIsAddedToWatchList = true
                                        DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                                        
                                    }else{
                                        
                                        let itemModel : ItemModel = ItemModel()
                                        itemModel.ItemId = productObject.id
                                        itemModel.ItemIsAddedToWatchList = true
                                        DatabaseHelper.sharedHelper.insertItem(item: itemModel)
                                        
                                    }
                                    
                                }else{
                                    
                                }
                            }
                            
                            let _ = NetworkManager.sharedManager.request(apiObject:self.watchlistAdd)
                        }
                        
                    }
                        
                    else{
                        
                        // Remove from Portfolio
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                        
                        self.watchlistDelete.watchListID = productObject.id
                        self.watchlistDelete.didCompleteRequest = { [weak self] success in
                            
                            MBProgressHUD.hide(for: self!.view, animated: true)
                            if(success){
                                sender.setImage(UIImage(named: "Watchlist-Off-Icon"), for: .normal)
                                productObject.addToWatchList(isAdded: false)
                                
                                if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: productObject.id){
                                    
                                    let itemModel  = ItemModel(product: productInfo)
                                    itemModel.ItemIsAddedToWatchList = false
                                    DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                                    
                                }else{
                                    
                                    let itemModel : ItemModel = ItemModel()
                                    itemModel.ItemId = productObject.id
                                    itemModel.ItemIsAddedToWatchList = false
                                    DatabaseHelper.sharedHelper.insertItem(item: itemModel)
                                    
                                }
                                
                            }else{
                                
                            }
                        }
                        
                        let _ = NetworkManager.sharedManager.request(apiObject:self.watchlistDelete)
                        
                    }
            } ,
                failure : {
                    // Failure Call Back
                    ()->() in
                    
            })
        }
    }
    
    //MARK:- User Rating Delegate
    
    func didSelectCancelButton(){
        
    }
    
    func didSelectRatingOptionWithRating(rating: Int){
        
        self.dataModel!.userRated = true
        
        productRatingAPIObject.productID = (self.dataModel?.id)!
        productRatingAPIObject.rating = rating
        productRatingAPIObject.didCompleteRequest = { [weak self] success in
            
            if(success){
                
                self!.dataModel?.totalRating += 1
                self!.dataModel?.productRating = ((self!.dataModel?.productRating)! + Float(rating)) / ((self!.dataModel?.totalRating)! > 1 ? 2 : 1)
                self!.productRatingView.removeFromSuperview()
                self!.setRatingView()
                
                if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: (self!.dataModel?.id)!){
                    
                    let itemModel  = ItemModel(product: productInfo)
                    itemModel.ItemIsRated = true
                    DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                    
                }else{
                    
                    let itemModel : ItemModel = ItemModel()
                    itemModel.ItemId = (self!.dataModel?.id)!
                    itemModel.ItemIsRated = true
                    DatabaseHelper.sharedHelper.insertItem(item: itemModel)
                    
                }
                
            }else{
                
                JSSAlertView().danger((sharedAppDelegate.window?.rootViewController)!, title: "Error", text: self!.productRatingAPIObject.message)
            }
        }
        
        let _ = NetworkManager.sharedManager.request(apiObject:productRatingAPIObject)
        
        // Call API and send User rating
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func mergeImage(baseImage : UIImage) -> UIImage{
        
        let bottomImage = baseImage
        let topImage = UIImage(named: "Seller-Image-Reported")
        
        UIGraphicsBeginImageContext(baseImage.size)
        
        let areaSize = CGRect(x: 0, y: 0, width: baseImage.size.width, height: baseImage.size.height)
        bottomImage.draw(in: areaSize)
        
        topImage!.draw(in: CGRect(x: (bottomImage.size.width - topImage!.size.width)/2 , y: (bottomImage.size.height - topImage!.size.height)/2, width: topImage!.size.width, height: topImage!.size.height))
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
        
    }

}
