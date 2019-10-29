//
//  PortfolioProductDetailViewController.swift
//  Swagafied
//
//  Created by Amitabha on 25/10/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit
import PureLayout
import MBProgressHUD
import JSSAlertView
import Kingfisher

enum Source{
    case timeline
    case portfolio
    case watchlist
}

class PortfolioProductDetailViewController: BaseViewController {
    
    var source : Source?
    var shoeSizePicker : ShoeSizePicker!
    var productDetailAPI = ProductDetail()
    let likeProductAPIObject = LikeProductAPI()
    let unlikeProductAPIObject = UnlikeProductAPI()
    private var dataModel : PortfolioWatchListBaseObject?
    var dataModelPortfolio : Portfoliolist?{
        didSet{
            dataModel = dataModelPortfolio
        }
    }
    var dataModelWatchList : WatchlistObject?{
        didSet{
            dataModel = dataModelWatchList
        }
    }
    var productImage: UIImage?
    let portfolioAdd = AddToPortfolio()
    let portfolioDelete = RemoveFromPortfolio()
    let watchlistAdd = AddToWatchlist()
    let watchlistDelete = RemoveFromWatchlist()
    var shoeSelectedData : (String,String,String)!
    var updatePortfolioAPI = UpdatePortfolioAPI()
    var updateWatchlistAPI = UpdateWatchlistAPI()
    
    //MARK:- IBOutlet variables -
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var addToWatchListButton: UIButton!
    @IBOutlet weak var portfolioButton: UIButton!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var sneakerFolioButton: UIButton!
    @IBOutlet weak var sizePickerButton: UIButton!
    
    //MARK:- View Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Add like button to navigation bar as left item
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "Back-Arrow"), for: .normal)
        self.navigationBar.addLeftBarButton(leftButton: backButton)
        
        // Add like button to navigation bar as right item
//        let filterButton = UIButton()
//        filterButton.setImage(UIImage(named: "Menu-Icon"), for: .normal)
//        
//        self.navigationBar.addRightBarButtons(rightButtons: [filterButton])
        self.shadowImageView.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if source == .watchlist{
            self.navigationBar.pageHeader = "Watchlist"
        }else if source == .timeline {
            self.navigationBar.pageHeader = "Timeline"
        }else{
            self.navigationBar.pageHeader = "Portfolio"
        }
        
        if source == .watchlist{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                self.sneakerFolioButton.setTitle("#Find-My-Kicks", for: .normal)
            }
        }
        
        if source == .timeline {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                self.setBottomView()
            }
        }
        
        priceTextField.text = ""
        sizeTextField.text = ""
        
        if self.navigationBar.pageHeader == "Watchlist"{
            sizeLabel.text = "Needed Size:  \((dataModel?.usSize) ?? "")"
            priceLabel.text = "Willing To Pay:  $\((dataModel?.price) ?? "")"
        }else if self.navigationBar.pageHeader == "Portfolio"{
            sizeLabel.text = "Size:  \((dataModel?.usSize) ?? "")"
            priceLabel.text = "Paid Price:  $\((dataModel?.price) ?? "")"
        }
        
        
        imageView.image = productImage
        
        self.shareButton.setImage(UIImage(named: "Share-Icon"), for: .normal)
        self.likeButton.setImage(UIImage(named: "Like-Icon"), for: .normal)
        self.portfolioButton.setImage(UIImage(named: "Portfolio-Off-Icon"), for: .normal)
        self.addToWatchListButton.setImage(UIImage(named: "Watchlist-Off-Icon"), for: .normal)
        
        if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: (dataModel?.productId)!){
            
            if (productInfo.isShared?.boolValue)! == true{
                self.shareButton.setImage(UIImage(named: "share-selected"), for: .normal)
            }
            
            if (productInfo.isLiked?.boolValue)! == true{
                self.likeButton.setImage(UIImage(named: "like-selected"), for: .normal)
            }
            
            if (productInfo.isAddedToPortfolio?.boolValue)! == true{
                self.portfolioButton.setImage(UIImage(named: "Portfolio-On-Icon-1"), for: .normal)
            }
            
            if (productInfo.isAddedToWishList?.boolValue)! == true{
                self.addToWatchListButton.setImage(UIImage(named: "Watchlist-On-Icon"), for: .normal)
            }
        
        }
        getPoductDetail()
        
    }
    
    func setBottomView(){
        let bottomView = OthersPortfolioBottomView()
        self.view.addSubview(bottomView)
        
        bottomView.autoPinEdge(.leading, to: .leading, of: self.view, withOffset: 0)
        bottomView.autoPinEdge(.trailing , to: .trailing, of: self.view, withOffset: 0)
        bottomView.autoPinEdge(.bottom , to: .bottom, of: self.view, withOffset: 0)
        bottomView.autoSetDimension(.height, toSize: 50)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPoductDetail(){
        
        productDetailAPI.productID = dataModel?.productId
        
        productDetailAPI.didCompleteRequest = { [weak self] success in
            
            let catagories = self!.productDetailAPI.product!.productCatagory.components(separatedBy: ",")
            if catagories.count > 0{
                self!.productCategoryLabel.text = catagories.first ?? "Not Found"
            }
            self!.productTitleLabel.text = self!.productDetailAPI.product!.productName ?? ""
        }
        
        let _ = NetworkManager.sharedManager.request(apiObject:productDetailAPI)
    }
    
    //MARK:- Navigatin Bar Delegate -
    
    override func didSelectLeftButton(sender:UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didSelectRightButton(sender:UIButton) {
        WindowManager.sharedManager.showMenu()
    }
    
   // MARK: - Button-Actions -

    @IBAction func sizePickerButtonAction(_ sender: AnyObject) {
        
        shoeSizePicker = ShoeSizePicker()
        self.view.addSubview(shoeSizePicker)
        
        shoeSizePicker.autoPinEdge(.top, to: .top, of: self.view)
        shoeSizePicker.autoPinEdge(.trailing, to: .trailing, of: self.view)
        shoeSizePicker.autoPinEdge(.leading, to: .leading, of: self.view)
        shoeSizePicker.autoPinEdge(.bottom, to: .bottom, of: self.view)
        
        shoeSizePicker.cancelActionCompletionHandler = {
            ()->() in
            
        }
        
        shoeSizePicker.selectActionCompletionHandler = {
            (selectedID,size,price) -> () in
            
            self.shoeSelectedData = (selectedID,size,price)
            self.sizeTextField.text = "  \(size)"
            self.priceTextField.text = "  $\(price)"
            
        }
        
    }
    
    @IBAction func infoButtonAction(_ sender: AnyObject) {
        showProductDetailPage()
    }
    
    @IBAction func shareButtonAction(_ sender: AnyObject) {
        
        if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: (dataModel?.productId)!){
            
            if (productInfo.isShared?.boolValue)! == false{
                
                let text = "Find Lit Kicks @Swagafied. Download the app"
                let vc = UIActivityViewController(activityItems: [productImage!,text], applicationActivities: [])
                self.present(vc, animated: true, completion: nil)
                
                //String?, Bool, [AnyObject]?, NSError?
                // (UIActivityType?, Bool, [Any]?, Error?) -> Swift.Void
                
                vc.completionWithItemsHandler = { (activityType, completed , returnedItems, error) -> Void in
                    
                    if error == nil && completed{
                        
                        // Call Share API here
                    
                        sender.setImage(UIImage(named: "share-selected"), for: .normal)
                        
                        if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: (self.dataModel?.productId)!){
                            
                            let itemModel  = ItemModel(product: productInfo)
                            itemModel.ItemIsShared = true
                            DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                            
                        }else{
                            
                            let itemModel : ItemModel = ItemModel()
                            itemModel.ItemId = (self.dataModel?.productId)!
                            itemModel.ItemIsShared = true
                            DatabaseHelper.sharedHelper.insertItem(item: itemModel)
                            
                        }
                        
                    }
                }
                
            }
            
        }
        
    }
    
    @IBAction func likeButtonAction(_ sender: AnyObject) {
        
        if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: (dataModel?.productId)!){
            
            if (productInfo.isLiked?.boolValue)! == false{
                
                self.likeProductAPIObject.didCompleteRequest = { [weak self] success in
                    
                    MBProgressHUD.hide(for: self!.view, animated: true)
                    if(success){
                        sender.setImage(UIImage(named: "like-selected"), for: .normal)
                        
                        if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: (self?.dataModel?.productId)!){
                            
                            let itemModel  = ItemModel(product: productInfo)
                            itemModel.ItemIsLiked = true
                            DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                            
                        }else{
                            
                            let itemModel : ItemModel = ItemModel()
                            itemModel.ItemId = (self?.dataModel?.productId)!
                            itemModel.ItemIsLiked = true
                            DatabaseHelper.sharedHelper.insertItem(item: itemModel)
                            
                        }
                        
                    }else{
                        
                    }
                }
                
                let _ = NetworkManager.sharedManager.request(apiObject:self.likeProductAPIObject)
                
            }else{
                
                self.unlikeProductAPIObject.didCompleteRequest = { [weak self] success in
                    MBProgressHUD.hide(for: self!.view, animated: true)
                    if(success){
                        sender.setImage(UIImage(named: "Like-Icon"), for: .normal)
                        
                        if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: (self?.dataModel?.productId)!){
                            
                            let itemModel  = ItemModel(product: productInfo)
                            itemModel.ItemIsLiked = false
                            DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                            
                        }
                        
                    }else{
                        
                    }
                }
                
                let _ = NetworkManager.sharedManager.request(apiObject:self.unlikeProductAPIObject)
            }
        }
        
    }
    
    @IBAction func watchListButtonAction(_ sender: AnyObject) {
        
        if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: (dataModel?.productId)!){
            
            if (productInfo.isAddedToWishList?.boolValue)! == true{
                
                let alert = UIAlertController(title: "Watchlist Update", message: "Are you sure you want to remove this item from your watchlist?", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
                    action in
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    
                    self.watchlistDelete.watchListID = (self.dataModel?.productId)!
                    self.watchlistDelete.didCompleteRequest = { [weak self] success in
                        
                        MBProgressHUD.hide(for: self!.view, animated: true)
                        if(success){
                            
                            self!.addToWatchListButton.setImage(UIImage(named: "Watchlist-Off-Icon"), for: .normal)
                            let itemModel  = ItemModel(product: productInfo)
                            itemModel.ItemIsAddedToWatchList = false
                            DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                            
                        }else{
                            
                        }
                    }
                    
                    let _ = NetworkManager.sharedManager.request(apiObject:self.watchlistDelete)
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                self.watchlistAdd.productID = (dataModel?.productId)!
                self.watchlistAdd.productSize = (dataModel?.size) ?? "4"
                self.watchlistAdd.productPrice = (dataModel?.price) ?? "---"
                self.watchlistAdd.didCompleteRequest = { [weak self] success in
                    
                    MBProgressHUD.hide(for: self!.view, animated: true)
                    if(success){
                        
                        self!.addToWatchListButton.setImage(UIImage(named: "Watchlist-On-Icon"), for: .normal)
                        
                        let itemModel  = ItemModel(product: productInfo)
                        itemModel.ItemIsAddedToWatchList = true
                        DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                        
                    }else{
                        
                    }
                }
                
                let _ = NetworkManager.sharedManager.request(apiObject:self.watchlistAdd)
            }
            
        }
        
    }
    
    @IBAction func portfolioButtonAction(_ sender: AnyObject) {
        
        if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: (dataModel?.productId)!){
            
            if (productInfo.isAddedToPortfolio?.boolValue)! == true{
                
                let alert = UIAlertController(title: "Portfolio Update", message: "Are you sure you want to remove this item from your portfolio?", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
                    action in
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    
                    self.portfolioDelete.portfolioID = (self.dataModel?.productId)!
                    self.portfolioDelete.didCompleteRequest = { [weak self] success in
                        
                        MBProgressHUD.hide(for: self!.view, animated: true)
                        if(success){
                            self!.portfolioButton.setImage(UIImage(named: "Portfolio-Off-Icon"), for: .normal)
                            let itemModel  = ItemModel(product: productInfo)
                            itemModel.ItemIsAddedToPortfolio = false
                            DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                            
                        }else{
                            
                        }
                    }
                    
                    let _ = NetworkManager.sharedManager.request(apiObject:self.portfolioDelete)
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                self.portfolioAdd.productID = (dataModel?.productId)!
                self.portfolioAdd.productSize = (dataModel?.size)!
                self.portfolioAdd.productPrice = (dataModel?.price)!
                self.portfolioAdd.didCompleteRequest = { [weak self] success in
                    
                    MBProgressHUD.hide(for: self!.view, animated: true)
                    if(success){
                        
                        self!.portfolioButton.setImage(UIImage(named: "Portfolio-On-Icon-1"), for: .normal)
                        
                        let itemModel  = ItemModel(product: productInfo)
                        itemModel.ItemIsAddedToPortfolio = true
                        DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                        
                    }else{
                        
                    }
                }
                
                let _ = NetworkManager.sharedManager.request(apiObject:self.portfolioAdd)
            }
            
        }
    }
    
    @IBAction func sneakerFolioButtonAction(_ sender: AnyObject) {
        
        if self.navigationBar.pageHeader == "Watchlist"{
            
            if let shoeSizeData = self.shoeSelectedData{
                
                updateWatchlistAPI.watchlistID = dataModel?.id
                updateWatchlistAPI.sizeID = shoeSizeData.0
                updateWatchlistAPI.price = shoeSizeData.2
                
                updateWatchlistAPI.didCompleteRequest = {
                    (success) -> () in
                    
                    if success{
                        
                        if self.navigationBar.pageHeader == "Watchlist"{
                            self.sizeLabel.text = "Needed Size:  \((shoeSizeData.1))"
                            self.priceLabel.text = "Willing To Pay:  $\((shoeSizeData.2))"
                        }else if self.navigationBar.pageHeader == "Portfolio"{
                            self.sizeLabel.text = "Size:  \(shoeSizeData.1)"
                            self.priceLabel.text = "Paid Price:  $\(shoeSizeData.2)"
                        }
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                    if self.navigationBar.pageHeader == "Watchlist"{
                        self.sizeLabel.text = "Needed Size:  \((shoeSizeData.1))"
                        self.priceLabel.text = "Willing To Pay:  $\((shoeSizeData.2))"
                    }else if self.navigationBar.pageHeader == "Portfolio"{
                        self.sizeLabel.text = "Size:  \(shoeSizeData.1)"
                        self.priceLabel.text = "Paid Price:  $\(shoeSizeData.2)"
                    }
                }
                
                let _ = NetworkManager.sharedManager.request(apiObject:updateWatchlistAPI)
            }
        }
        else if self.navigationBar.pageHeader == "Portfolio"{
            
            if let shoeSizeData = self.shoeSelectedData{
                
                updatePortfolioAPI.portfolioID = dataModel?.id
                updatePortfolioAPI.sizeID = shoeSizeData.0
                updatePortfolioAPI.price = shoeSizeData.2
                
                updatePortfolioAPI.didCompleteRequest = {
                    (success) -> () in
                    
                    if success{
                        if self.navigationBar.pageHeader == "Watchlist"{
                            self.sizeLabel.text = "Needed Size:  \((shoeSizeData.1))"
                            self.priceLabel.text = "Willing To Pay:  $\((shoeSizeData.2))"
                        }else if self.navigationBar.pageHeader == "Portfolio"{
                            self.sizeLabel.text = "Size:  \(shoeSizeData.1)"
                            self.priceLabel.text = "Paid Price:  $\(shoeSizeData.2)"
                        }
                    }
                }
                
                let _ = NetworkManager.sharedManager.request(apiObject:updatePortfolioAPI)
            }
        }
    }
    
    // MARK: - Navigation -
    
    func showProductDetailPage(){
        self.performSegue(withIdentifier: Configuration.SegueNames.ShowProductDetailViewControllerFromPortfolio, sender: self)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Configuration.SegueNames.ShowProductDetailViewControllerFromPortfolio{
            
            let destinationVC : ProductDetailViewController = segue.destination as! ProductDetailViewController
            destinationVC.dataModel = productDetailAPI.product
            destinationVC.dataModel?.productMainImage = productImage
            
            if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: (dataModel?.productId)!){
                destinationVC.dataModel?.productLiked(isLiked: (productInfo.isLiked?.boolValue)!)
                destinationVC.dataModel?.addToPortfolio(isAdded: (productInfo.isAddedToPortfolio?.boolValue)!)
                destinationVC.dataModel?.addToWatchList(isAdded: (productInfo.isAddedToWishList?.boolValue)!)
                destinationVC.dataModel?.isShared = (productInfo.isShared?.boolValue)!
            }
        }
    }
    

}
