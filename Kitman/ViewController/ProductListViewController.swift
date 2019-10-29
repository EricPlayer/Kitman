//
//  ViewController.swift
//  Swagafied
//
//  Created by Amitabha on 04/07/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit
import PureLayout
import MBProgressHUD
import JSSAlertView
import Kingfisher
import GoogleMobileAds

class ProductListViewController: BaseViewController,ProductCellDelegate,ProductSearchDelegate, GADInterstitialDelegate {
    
    var adOn = false
    var timelineVC: TimeLineViewController!
    var interstitial: GADInterstitial!
    var timer: Timer?
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var productListTableView: UITableView!
    @IBOutlet weak var productSearchTextField: UITextField!
    
    var shoeSizePicker : ShoeSizePicker!
    let imageDownloaderManager = ImageDownloaderManager.sharedImageDownloaderManager
    var collectionFilterDataSource : Array<ProductObject> = Array<ProductObject>()
    var bufferProductArray : Array<ProductObject> = Array<ProductObject>()
    var dataSource : Array<ProductObject> = Array<ProductObject>(){
        didSet{
            
        }
    }
    let scroll = UIScrollView()
    var pageIndicator = UIPageControl()
    var launchScreenGoButton = UIButton()
    var isAdBannerOn = false
    var likeFilterOn = false
    var collectionFilterOn = false
    var collectionFilter : Array<String> = Array<String>()
    var likeButtonActionCallBack : ((Bool)-> ())?
    let pendingOperations = PendingOperations()
    var productSearchView : ProductSearch?
    let productListApiObject = ProductListAPI()
    let portfolioAdd = AddToPortfolio()
    let portfolioDelete = RemoveFromPortfolio()
    let watchlistAdd = AddToWatchlist()
    let watchlistDelete = RemoveFromWatchlist()
    let likeProductAPIObject = LikeProductAPI()
    let unlikeProductAPIObject = UnlikeProductAPI()
    let masterDataAPIObject = MasterDataParser()
    let likeButton = UIButton()
    
    var progressHud : MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineVC = loadViewControllerFromStroryboard(storyboard: Configuration.Storyboard.MainStoryBoard, viewControllerIndentifier:Configuration.ViewControllers.TimeLineViewController) as! TimeLineViewController
        
        configureVC()
        
        if (UIApplication.shared.delegate as! AppDelegate).isDataFetched == false{
            if ProductDataManager.sharedManager.isDataSaved(){
                
                self.bufferProductArray = ProductDataManager.sharedManager.dataSource!
                self.processArrayAndDownloadImage(products: Array(bufferProductArray[0...Configuration.ImagedownloadSettings.imageCountInSet]))
                
                for item in self.bufferProductArray{
                    print(item.productCatagory)
                }
                
            }else{
                
                // If data is saved then sava data in DB and load it back.
                ProductDataManager.sharedManager.saveData()
                self.bufferProductArray = ProductDataManager.sharedManager.dataSource!
                for item in self.bufferProductArray{
                    print(item.productCatagory)
                }
                self.processArrayAndDownloadImage(products: Array(bufferProductArray[0...Configuration.ImagedownloadSettings.imageCountInSet]))
//                getProductLists()
            }
            
        }else{
            bufferProductArray = (UIApplication.shared.delegate as! AppDelegate).dataSource
            self.dataSource = Array(bufferProductArray[0...Configuration.ImagedownloadSettings.imageCountInSet])
            productListTableView.reloadData()
        }
        
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(ProductListViewController.refreshTableView), name: NSNotification.Name(rawValue: Configuration.Notification.LogInSuccessful), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProductListViewController.refreshTableView), name: NSNotification.Name(rawValue: Configuration.Notification.LogOutSuccessful), object: nil)
        
        isAdBannerOn = true
        timer = Timer.scheduledTimer(timeInterval: 27, target: self, selector: #selector(showGoogleIAd), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.view.bringSubview(toFront: self.navigationBar)
        self.view.bringSubview(toFront: self.shadowImageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if likeFilterOn{
            loadLikedProduct()
            
        }else if collectionFilterOn{
            
        }else{
            
            if self.bufferProductArray.count > 0{
                self.dataSource = Array(bufferProductArray[0...imageDownloaderManager.downloadedIndex])
                self.productListTableView.reloadData()
                
            }
        }
        
        if (UserDefaults.standard.bool(forKey: Configuration.UserDefaultKeys.IsLaunched) == false){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                self.showWelcomeScreen()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.adOn = false
//        timer?.invalidate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        isAdBannerOn = false
    }
    
    func showWelcomeScreen(){
        
        UserDefaults.standard.set(true, forKey: Configuration.UserDefaultKeys.IsLaunched)
        
        let welcomeScreen1 = LaunchScreen()
        welcomeScreen1.descriptionTitle.text = "Welcome To Swagafied"
        welcomeScreen1.descriptionSubTitle.text = "The App just for kicks"
        welcomeScreen1.frame = self.view.bounds
        
        let welcomeScreen2 = LaunchScreen()
        welcomeScreen2.backgroundImageView.image = UIImage(named: "Welcome2")
        welcomeScreen2.descriptionTitle.text = "Our App is Straight Fire"
        welcomeScreen2.descriptionSubTitle.text = "It's made for users, by users. Its an easy way to Rate, Review, Like or Share\nevery dope pair of kicks on\nthe market."
        welcomeScreen2.frame = CGRect(x: Configuration.Sizes.ScreenWidth, y: 0, width: Configuration.Sizes.ScreenWidth, height: Configuration.Sizes.ScreenHeight)
        
        let welcomeScreen3 = LaunchScreen()
        welcomeScreen3.backgroundImageView.image = UIImage(named: "Welcome3")
        welcomeScreen3.descriptionTitle.text = "We've Made it Easy"
        welcomeScreen3.descriptionSubTitle.text = "Stay Up To Date With What's Trending.\nAdd Kicks You Own to Your Portfolio.\nCreate Your Own Watchlist."
        welcomeScreen3.frame = CGRect(x: 2*Configuration.Sizes.ScreenWidth, y: 0, width: Configuration.Sizes.ScreenWidth, height: Configuration.Sizes.ScreenHeight)
        
        
        scroll.backgroundColor = UIColor.white
        scroll.frame = self.view.bounds
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.delegate = self
        self.view.addSubview(scroll)
        scroll.contentSize = CGSize(width: 3*Configuration.Sizes.ScreenWidth, height: Configuration.Sizes.ScreenHeight)
        
        scroll.addSubview(welcomeScreen1)
        scroll.addSubview(welcomeScreen2)
        scroll.addSubview(welcomeScreen3)
        
        pageIndicator.numberOfPages = 3
        pageIndicator.currentPage = 0
        pageIndicator.frame = CGRect(x: (Configuration.Sizes.ScreenWidth-100)/2, y: (Configuration.Sizes.ScreenHeight-60), width: 100, height: 20)
        pageIndicator.currentPageIndicatorTintColor = UIColor.darkGray
        pageIndicator.pageIndicatorTintColor =
            UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1)
            // UIColor.init(colorLiteralRed: 0.80, green: 0.80, blue: 0.80, alpha: 1)
        self.view.addSubview(pageIndicator)
        
        launchScreenGoButton.frame = CGRect(x: (Configuration.Sizes.ScreenWidth-80), y: (Configuration.Sizes.ScreenHeight-75), width: 50, height: 50)
        
        launchScreenGoButton.setImage(UIImage(named: "Go-Button"), for: .normal)
        launchScreenGoButton.addTarget(self, action: #selector(self.hideLaunchScreen), for: .touchUpInside)
        self.view.addSubview(launchScreenGoButton)
        launchScreenGoButton.isHidden = true
    }
    
    @objc func hideLaunchScreen(){
        launchScreenGoButton.removeFromSuperview()
        scroll.removeFromSuperview()
        pageIndicator.removeFromSuperview()
    }
    
    @objc func refreshTableView(){
        
        if self.bufferProductArray.count > 0{
            self.dataSource = Array(bufferProductArray[0...imageDownloaderManager.downloadedIndex])
            self.productListTableView.reloadData()
            
        }
    }
    
    @objc func showGoogleIAd() {
//        interstitial = GADInterstitial(adUnitID: Configuration.API.adUnitID )
//        interstitial.delegate = self;
//        // Banner Ad : ca-app-pub-6626593325937491/9886495568
//        let request = GADRequest()
//        // Request test ads on devices you specify. Your test device ID is printed to the console when
//        // an ad request is made.
//        interstitial.load(request)
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        
        if ad.isReady {
            ad.present(fromRootViewController: self)
        }else{
            print("Ad Not Ready")
        }
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        isAdBannerOn = false
    }
    
    func configureVC(){
        
        let cellNib = UINib.init(nibName: Configuration.XIBNames.ProductListTableViewCellXIB, bundle: Bundle.main)
        self.productListTableView.register(cellNib, forCellReuseIdentifier: Configuration.CellIdentifier.ProductListTableViewCell)
        
        self.shadowImageView.isHidden = false
        
        // Add like button to navigation bar as left item
        
        likeButton.setImage(UIImage(named: "black-tag"), for: .normal)
        
        let timeLine = UIButton()
        timeLine.setImage(UIImage(named: "timline-icon"), for: .normal)
        self.navigationBar.addLeftBarButtons(leftButtons: [likeButton,timeLine])
        
        // Add like button to navigation bar as right item
        let filterButton = UIButton()
        filterButton.setImage(UIImage(named: "Menu-Icon"), for: .normal)
        self.navigationBar.addRightBarButtons(rightButtons: [filterButton])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MBProgressHUD.hideHUDForView(self!.view, animated: true)
    //MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    func getProductLists(){
        
         productListApiObject.didCompleteRequest = { [weak self] success in
            
            if(success){
                
                if (self!.productListApiObject.pageNumber == 0){
                    self!.processArrayAndDownloadImage(products: (self?.productListApiObject.products)!)
                }
                
                self!.productListApiObject.pageNumber =  self!.productListApiObject.pageNumber + 1
                self!.bufferProductArray = self!.bufferProductArray + (self!.productListApiObject.products)
                
                if self!.productListApiObject.products.count == 30{
                    self!.getProductLists()
                }else{
                    
                    (UIApplication.shared.delegate as! AppDelegate).isDataFetched = true
                    (UIApplication.shared.delegate as! AppDelegate).dataSource = self!.bufferProductArray
                    
                    ProductDataManager.sharedManager.saveData(dataObjects: self!.bufferProductArray)
                    
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self!.view, animated: true)
                    }
                }
                
            }else{
                
            }
        }
        
        let _ = NetworkManager.sharedManager.request(apiObject: productListApiObject)
        
        DispatchQueue.main.async {
            if (self.productListApiObject.pageNumber == 0){
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.label.numberOfLines = 3
                hud.label.text = "Hold up a sec\n while we pull up\n all of our dope kicks. "
            }
        }
    }
    
    func processArrayAndDownloadImage( products : Array<ProductObject> , setIndex : Bool = true ){
        
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        let imageURLArray = products.map({ (productObject) -> String in
            return productObject.localImageUrl!
        })
        
        let imageDownloaderManager = ImageDownloaderManager.sharedImageDownloaderManager
        imageDownloaderManager.mainImageURLs = imageURLArray
        if setIndex{
            imageDownloaderManager.idx = 0
            imageDownloaderManager.downloadedIndex = 0
        }
        
        imageDownloaderManager.completionHandler = { (index,success) -> () in
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
            var products: Array<ProductObject> = products
            self.dataSource = Array(products[0...index])
            self.productListTableView.reloadData()
            
        }
        
        imageDownloaderManager.downloadNextSetImage()
        
    }
    
    @IBAction func searchButtonAction(_ sender: AnyObject) {
        
        if (productSearchTextField.text?.characters.count)! > 0{
            let text = productSearchTextField.text
            
            let filterData = bufferProductArray.filter({ (product) -> Bool in
                
                if let date  = DateTimeFormatter.sharedFormatter.convertStringToDate(dateString: product.productReleaseDate!){
                    let year = "\(date.year)"
                    
                    if let searchText = text{
            
                        return product.productCatagory.lowercased().contains(searchText.lowercased()) || product.productCollection.lowercased().contains(searchText.lowercased()) || product.productName!.lowercased().contains(searchText.lowercased()) || product.color!.lowercased().contains(searchText.lowercased()) || year.lowercased().contains(searchText.lowercased())
                        
                    }else{
                        return false
                    }
                    
                }else{
                
                    if let searchText = text{
                        
                        return product.productCatagory.lowercased().contains(searchText.lowercased()) || product.productCollection.lowercased().contains(searchText.lowercased()) || product.productName!.lowercased().contains(searchText.lowercased()) || product.color!.lowercased().contains(searchText.lowercased())
                        
                    }else{
                        return false
                    }
                }
            })
            
            if filterData.count == 0{
                
                let alert = UIAlertController(title: "Search Results", message: "Sorry, no items match your search", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }else{
                
                dataSource = filterData
                productListTableView.reloadData()
                productListTableView.setContentOffset(CGPoint(x: 0, y: 0), animated:true)
            }
            
        }
        else{
            
            self.dataSource = Array(bufferProductArray[0...imageDownloaderManager.downloadedIndex])
            self.productListTableView.reloadData()
            productListTableView.setContentOffset(CGPoint(x: 0, y: 0), animated:true)
            
        }
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let allCollectionList : AllCollectionsAPI = AllCollectionsAPI()
        allCollectionList.didCompleteRequest = { [weak self] success in
            
            MBProgressHUD.hide(for: self!.view, animated: true)
            if(success){
                print("success")
                
                self!.productSearchView = ProductSearch()
                self!.productSearchView!.delegate = self
                self!.view.addSubview(self!.productSearchView!)
                
                self!.productSearchView!.autoPinEdge(.top, to: .top, of: self!.view)
                self!.productSearchView!.autoPinEdge(.leading, to: .leading, of: self!.view)
                self!.productSearchView!.autoPinEdge(.trailing, to: .trailing, of: self!.view)
                self!.productSearchView!.autoSetDimension(.height, toSize: Configuration.Sizes.ScreenHeight)
                
                self!.productSearchView?.dataSource = allCollectionList.collections
                self!.productSearchView?.selectedCollections = self!.collectionFilter
                self!.productSearchView?.loadBrands()
                
            }
            else{
                
            }
        }
        
        let _ = NetworkManager.sharedManager.request(apiObject: allCollectionList)
        
    }
    
    //MARK:- Navigatin Bar Delegate -
    
    override func didSelectLeftButton(sender:UIButton) {
        
        switch sender.tag {
        case 0:
            
            // Show Alert View
            self.showAlertView(title: "Whoops!", message: "You'll have to Login or Signup to access this feature.", cancelButtonTitle: "Cancel", okButtonTitle: "Ok")
            
            // Alert action hndler
            self.okAlertAction = {
                ()->() in
                
                self.loginCallBackAction(success: {
                    () -> () in
                    
                    if self.likeFilterOn{
                        
                        self.likeFilterOn = !self.likeFilterOn
                        self.dataSource = Array(self.bufferProductArray[0...self.imageDownloaderManager.downloadedIndex])
                        self.productListTableView.reloadData()
                        self.productListTableView.setContentOffset(CGPoint(x: 0, y: 0), animated:true)
                        
                        sender.setImage(UIImage(named: "black-tag"), for: .normal)
                        
                    }else{
                        self.loadLikedProduct()
                    }
                    
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
                    
                    self.timer?.invalidate()
                    let navc = UINavigationController(rootViewController: self.timelineVC)
                    navc.setNavigationBarHidden(true, animated: false)
                    WindowManager.sharedManager.setViewController(selectedViewController: navc)
                    
                }, failure: {() -> () in
                    
                })
                
            }
            
            break
            
        default:
            break
        }
    
    }
    
    func loadLikedProduct(){
        
        likeFilterOn = true
        let filter = NSPredicate(format: "isLiked == %@", NSNumber(value: true))
        if let products : [ProductInfo] = DatabaseHelper.sharedHelper.fetchProductListWithPredicate(filter: filter){
            
            let likedProductIDs = products.map({ (productInfo : ProductInfo) -> String in
                return productInfo.productID!
            })
            
            
            let filterData = bufferProductArray.filter({
                likedProductIDs.contains($0.id)
            })
            
            if filterData.count > 0{
                
                likeButton.setImage(UIImage(named: "like-dashboard-selected"), for: .normal)
                
                dataSource = filterData
                productListTableView.reloadData()
                productListTableView.setContentOffset(CGPoint(x: 0, y: 0), animated:true)
            }else{
                
                likeFilterOn = !likeFilterOn
                
                let alert = UIAlertController(title: "Whoops!", message: "You haven't tagged any items to save and display in this screen. Try tagging a pair of kicks you like now to see how it works." , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alertAction) -> Void in
                    
                }))
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }

            }
        }
    }
    
    override func didSelectRightButton(sender:UIButton) {
        timer?.invalidate()
        WindowManager.sharedManager.showMenu()
    }
    
    
    //MARK:- Product Search View Delegate -
    
    func didSelectCancelButton() {
        self.productSearchView!.removeFromSuperview()
    }
    
    func didSelectResetButton() {
        self.productSearchView!.removeFromSuperview()
    }
    
    func didSelectMakeItHappenButton(selectedValues: Array<String>) {
        
        self.productSearchView!.removeFromSuperview()
        
        if selectedValues.count > 0{
            
            collectionFilter = selectedValues
            
            let filterData = bufferProductArray.filter({
                
                let array = $0.productCollection.components(separatedBy: ",")
                
                let listSet = Set(collectionFilter)
                let findListSet = Set(array)
                let allElemsContained = findListSet.intersection(listSet)
                
                if allElemsContained.count == 0{
                    return false
                }else{
                    return true
                }
                
            })
            
            if filterData.count > 0{
                
                print("total : \(filterData.count)")
                collectionFilterDataSource = filterData
                let toIndex = filterData.count > Configuration.ImagedownloadSettings.imageCountInSet ? Configuration.ImagedownloadSettings.imageCountInSet : filterData.count-1
                dataSource = Array(collectionFilterDataSource[0...toIndex])
                self.processArrayAndDownloadImage(products: filterData)
                productListTableView.setContentOffset(CGPoint(x: 0, y: 0), animated:true)
                collectionFilterOn = true
                
                filterButton.setImage(UIImage(named: "Filter-checked-Icon"), for: .normal)
                
            }else{
                
                let alert = UIAlertController(title: "Collection Alert", message: "Sorry, no items match your search", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                collectionFilter.removeAll()
                self.dataSource = Array(bufferProductArray[0...imageDownloaderManager.downloadedIndex])
                self.productListTableView.reloadData()
                productListTableView.setContentOffset(CGPoint(x: 0, y: 0), animated:true)
                
                filterButton.setImage(UIImage(named: "Filter-unhecked-Icon"), for: .normal)
            }
            
        }else{
            
            collectionFilterOn = false
            collectionFilter.removeAll()
            self.dataSource = Array(bufferProductArray[0...imageDownloaderManager.downloadedIndex])
            self.productListTableView.reloadData()
            productListTableView.setContentOffset(CGPoint(x: 0, y: 0), animated:true)
            
            filterButton.setImage(UIImage(named: "Filter-unhecked-Icon"), for: .normal)
        }
        
        
    }
    
    
    //MARK:- Product Cell View Delegate -
    
    /**
     Details Button delegate method
     */
    func didSelectDetailsButton(indexPath: IndexPath){
        
        timer?.invalidate()
        self.productListTableView.selectRow(at: indexPath as IndexPath, animated: true, scrollPosition: .none)
        performSegue(withIdentifier: Configuration.SegueNames.ShowProductDetailViewController, sender: self)
    }
    
    /**
     Select Button delegate method
     */
    
    func didSelectLikeButton(indexPath: IndexPath) {
       
        if likeFilterOn == false{
            
            // Show Alert View
            self.showAlertView(title: "Whoops!", message: "You'll have to Login or Signup to access this page.", cancelButtonTitle: "Cancel", okButtonTitle: "Ok")
            
            
            self.okAlertAction = {
                ()->() in
                
                self.loginCallBackAction(
                    success: {
                        // Success Call Back
                        () -> () in
                        
                        let productObject : ProductObject = self.dataSource[indexPath.row]
                        let productListCell : ProductListCell = self.productListTableView.cellForRow(at: indexPath as IndexPath) as! ProductListCell
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                        
                        self.likeProductAPIObject.productID = productObject.id
                        
                        self.likeProductAPIObject.didCompleteRequest = { [weak self] success in
                            
                            MBProgressHUD.hide(for: self!.view, animated: true)
                            if(success){
                                productListCell.likeButton.setImage(UIImage(named: "like-selected"), for: .normal)
                                productObject.productLiked(isLiked: true)
                                
                                if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: productObject.id){
                                    
                                    let itemModel  = ItemModel(product: productInfo)
                                    itemModel.ItemIsLiked = true
                                    DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                                    
                                }else{
                                    
                                    let itemModel : ItemModel = ItemModel()
                                    itemModel.ItemId = productObject.id
                                    itemModel.ItemIsLiked = true
                                    DatabaseHelper.sharedHelper.insertItem(item: itemModel)
                                    
                                }
                                
                            }else{
                                
                            }
                        }
                        
                        self.unlikeProductAPIObject.didCompleteRequest = { [weak self] success in
                            MBProgressHUD.hide(for: self!.view, animated: true)
                            if(success){
                                productListCell.likeButton.setImage(UIImage(named: "Like-Icon"), for: .normal)
                                productObject.productLiked(isLiked: false)
                                
                                if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: productObject.id){
                                    
                                    let itemModel  = ItemModel(product: productInfo)
                                    itemModel.ItemIsLiked = false
                                    DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                                    
                                }
                                
                            }else{
                                
                            }
                        }
                        
                        if productObject.isLiked {
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
    }
    
    /**
     Share Button delegate method
     */
    func didSelectShareButton(indexPath: IndexPath){
        
        // Show Alert View
        self.showAlertView(title: "Whoops!", message: "You'll have to Login or Signup to access this page.", cancelButtonTitle: "Cancel", okButtonTitle: "Ok")
        
        // Alert action hndler
        self.okAlertAction = {
            ()->() in
            
            self.loginCallBackAction(
                success: {
                    // Success Call Back
                    () -> () in
                    
                    let productObject : ProductObject = self.dataSource[indexPath.row]
                    
                    if productObject.isShared == false{
                        let text = "Find Lit Kicks @Swagafied. Download the app"
                        if let image = productObject.productMainImage {
                            
                            let vc = UIActivityViewController(activityItems: [image,text], applicationActivities: [])
                            self.present(vc, animated: true, completion: nil)
                            
                            //String?, Bool, [AnyObject]?, NSError?
                            // (UIActivityType?, Bool, [Any]?, Error?) -> Swift.Void
                            
                            vc.completionWithItemsHandler = { (activityType, completed , returnedItems, error) -> Void in
                                
                                if error == nil && completed{
                                    
                                    // Call Share API here
                                    
                                    let productObject : ProductObject = self.dataSource[indexPath.row]
                                    let productListCell : ProductListCell = self.productListTableView.cellForRow(at: indexPath as IndexPath) as! ProductListCell
                                    productObject.isShared = true
                                    productListCell.shareButton.setImage(UIImage(named: "share-selected"), for: .normal)
                                    
                                    if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: productObject.id){
                                        
                                        let itemModel  = ItemModel(product: productInfo)
                                        itemModel.ItemIsShared = true
                                        DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                                        
                                    }else{
                                        
                                        let itemModel : ItemModel = ItemModel()
                                        itemModel.ItemId = productObject.id
                                        itemModel.ItemIsShared = true
                                        DatabaseHelper.sharedHelper.insertItem(item: itemModel)
                                        
                                    }
                                    
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
    
    /**
     Portfolio Button delegate method
     */
    func didSelectPortfolioButton(indexPath: IndexPath) {
        
        // Show Alert View
        self.showAlertView(title: "Whoops!", message: "You'll have to Login or Signup to access this page.", cancelButtonTitle: "Cancel", okButtonTitle: "Ok")
        
        // Alert action hndler
        self.okAlertAction = {
            ()->() in
            
            self.loginCallBackAction(
                success: {
                    // Success Call Back
                    () -> () in
                    
                    let productObject : ProductObject = self.dataSource[indexPath.row]
                    let productListCell : ProductListCell = self.productListTableView.cellForRow(at: indexPath as IndexPath) as! ProductListCell
                    
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
                                    
                                    productListCell.portfolioButton.setImage(UIImage(named: "Portfolio-On-Icon-1"), for: .normal)
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
                                productListCell.portfolioButton.setImage(UIImage(named: "Portfolio-Off-Icon"), for: .normal)
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
    
    /**
     Watchlist Button delegate method
     */
    func didSelectWatchlistButton(indexPath: IndexPath) {
        
        // Show Alert View
        self.showAlertView(title: "Whoops!", message: "You'll have to Login or Signup to access this page.", cancelButtonTitle: "Cancel", okButtonTitle: "Ok")
        
        // Alert action hndler
        self.okAlertAction = {
            ()->() in
            
            self.loginCallBackAction(
                success: {
                    // Success Call Back
                    () -> () in
                    
                    let productObject : ProductObject = self.dataSource[indexPath.row]
                    
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
                            
                            let productListCell : ProductListCell = self.productListTableView.cellForRow(at: indexPath as IndexPath) as! ProductListCell
                            MBProgressHUD.showAdded(to: self.view, animated: true)
                            
                            self.watchlistAdd.productID = productObject.id
                            self.watchlistAdd.productSize = selectedID
                            self.watchlistAdd.productPrice = price
                            self.watchlistAdd.didCompleteRequest = { [weak self] success in
                                
                                MBProgressHUD.hide(for: self!.view, animated: true)
                                if(success){
                                    
                                    productListCell.watchlistButton.setImage(UIImage(named: "Watchlist-On-Icon"), for: .normal)
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
                        
                        let productListCell : ProductListCell = self.productListTableView.cellForRow(at: indexPath as IndexPath) as! ProductListCell
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                        
                        self.watchlistDelete.watchListID = productObject.id
                        self.watchlistDelete.didCompleteRequest = { [weak self] success in
                            
                            MBProgressHUD.hide(for: self!.view, animated: true)
                            if(success){
                                productListCell.watchlistButton.setImage(UIImage(named: "Watchlist-Off-Icon"), for: .normal)
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
    
    
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        if (segue.identifier == Configuration.SegueNames.ShowProductDetailViewController){
            
            let indexPath = self.productListTableView.indexPathForSelectedRow
            let productListCell : ProductListCell = self.productListTableView.cellForRow(at: indexPath!) as! ProductListCell
            
            let detailVC = segue.destination as! ProductDetailViewController
            dataSource[indexPath!.row].productMainImage = productListCell.productImageView.image
            detailVC.dataModel = dataSource[indexPath!.row]
            
        }
     }

}

// MARK: - ScrollView Delegate
extension ProductListViewController : UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        suspendAllOperations()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        
        
        if !decelerate {
//            loadImagesForOnscreenCells()
//            resumeAllOperations()
        }
        
        if scrollView == scroll{
            
        }else{
            // UITableView only moves in one direction, y axis
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            
            // Change 10.0 to adjust the distance from bottom
            if maximumOffset - currentOffset <= 500.0 {
                
                if likeFilterOn == false && collectionFilterOn == false{
                    self.loadNextSetMainTableData()
                }else if collectionFilterOn == true{
                    
                    let imageURLArray = self.collectionFilterDataSource.map({ (productObject) -> String in
                        return productObject.localImageUrl!
                    })
                    
                    let imageDownloaderManager = ImageDownloaderManager.sharedImageDownloaderManager
                    let count = collectionFilterDataSource.count - dataSource.count
                    if count >= 30{
                        imageDownloaderManager.mainImageURLs = Array(imageURLArray[0...self.dataSource.count+29])
                    }else{
                        imageDownloaderManager.mainImageURLs = imageURLArray
                    }
        
                    imageDownloaderManager.currentIndex = 0
                    imageDownloaderManager.completionHandler = { (index,success) -> () in
                        
                        print("from 0 to \(index)")
                        
                        self.dataSource = Array(self.collectionFilterDataSource[0...index])
                        self.productListTableView.reloadData()
                        
                    }
                    
                    imageDownloaderManager.downloadNextSetImage()
                    
                }else if likeFilterOn == true{
                    
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == scroll{
            let newPage: Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
            pageIndicator.currentPage = newPage
            
            if newPage == 2{
                launchScreenGoButton.isHidden = false
            }else{
                launchScreenGoButton.isHidden = true
            }
        }
    }
    
    func suspendAllOperations () {
//        pendingOperations.downloadQueue.suspended = true
    }
    
    func resumeAllOperations () {
//        pendingOperations.downloadQueue.suspended = false
    }
 
    func loadImagesForOnscreenCells () {
        /*
        if let pathsArray = productListTableView.indexPathsForVisibleRows {
        
            let allPendingOperations = Set(Array(pendingOperations.downloadsInProgress.keys))
            
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray )
            toBeCancelled.subtractInPlace(visiblePaths)
            var toBeStarted = visiblePaths
            toBeStarted.subtractInPlace(allPendingOperations)
            
            for indexPath in toBeCancelled {
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                
            }
            
            for indexPath in toBeStarted {
                let indexPath = indexPath as NSIndexPath
                //self.productListTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

                let productListCell : ProductListCell = self.productListTableView.cellForRowAtIndexPath(indexPath) as! ProductListCell
                let productObject : ProductObject = dataSource[indexPath.row]
                if let urlString = productObject.localImageUrl{
                    
                    
                    
                    let urlStrin : String = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                    
                    let imagePath = fileInDocumentsDirectory("Image_\(urlStrin)")
                    
                    if NSFileManager.defaultManager().fileExistsAtPath(imagePath){
                        let image = loadImageFromPath(imagePath)
                        productObject.productMainImage = image
                        productListCell.productImageView.image = image
                    }else{
                        if let url = NSURL(string: urlStrin) {
                        //// ///
                        
                        let myCache = ImageCache(name: "my_cache")
                        
                        productListCell.productImageView.kf_setImageWithURL(url,
                                                                            placeholderImage: nil,
                                                                            optionsInfo: [KingfisherOptionsInfoItem.TargetCache(myCache)],
                                                                            progressBlock: { (receivedSize, totalSize) in
                            
                            },
                                                                            completionHandler: { (image, error, cacheType, imageURL) in
                                                                                productObject.productMainImage = image
                                                                                productListCell.productImageView.image = image
                                                                                
                                                                                // Save image to cache
                                                                                if let img = image{
                                                                                    if let imageData = UIImageJPEGRepresentation(img ,0.9){
                                                                                        let result = imageData.writeToFile(imagePath, atomically: true)
                                                                                        print(result)
                                                                                    }
                                                                                }
                                                                                
                        })
                        
                        /// ///
                    }
                    }
                }
            }
            
            
        }
         */
    }

    func loadNextSetMainTableData(){
        
        let imageURLArray = self.bufferProductArray.map({ (productObject) -> String in
            return productObject.localImageUrl!
        })
        
        let imageDownloaderManager = ImageDownloaderManager.sharedImageDownloaderManager
        imageDownloaderManager.mainImageURLs = imageURLArray
        imageDownloaderManager.completionHandler = { (index,success) -> () in
            
            print("from 0 to \(index)")
            
            self.dataSource = Array(self.bufferProductArray[0...index])
            self.productListTableView.reloadData()
            
        }
        
        imageDownloaderManager.downloadNextSetImage()
    }
    
    /*
    func startOperationsForPhotoRecord(photoDetails: PhotoRecord, indexPath: NSIndexPath){
        startDownloadForRecord(photoDetails, indexPath: indexPath)
    }
    
    func startDownloadForRecord(photoDetails: PhotoRecord, indexPath: NSIndexPath){
        
        if let downloadOperation = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = ImageDownloader(photoRecord: photoDetails)
        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                
                let productObject : ProductObject = self.dataSource[indexPath.row]
                productObject.productMainImage = downloader.photoRecord.image
                
                self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                self.productListTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    */
}

// MARK: - TableView Delegate
extension ProductListViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        timer?.invalidate()
        performSegue(withIdentifier: Configuration.SegueNames.ShowProductDetailViewController, sender: self)
    }
}

// MARK: - TableView DataSource
extension ProductListViewController : UITableViewDataSource{
    
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Configuration.Sizes.ProductTableCellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataSource.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let noticationItem = filteredNoticationItems[indexPath.row]
        
        let cell: ProductListCell = tableView.dequeueReusableCell(withIdentifier: Configuration.CellIdentifier.ProductListTableViewCell, for: indexPath) as! ProductListCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.indexPath = indexPath
    
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Configuration.NavigationBar.NavigationBarHeight-30
    }
    
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    private func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    private func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    @objc(tableView:willDisplayCell:forRowAtIndexPath:)
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cutsomCell : ProductListCell = cell as! ProductListCell
        
        let productObject : ProductObject = dataSource[indexPath.row]
        
        let catagories = productObject.productCatagory.components(separatedBy: ",")
        if catagories.count > 0{
            cutsomCell.productCatagoryLabel.text = catagories.first
        }
        
        cutsomCell.productTitleLabel.text = productObject.productName ?? ""
        cutsomCell.likeButton.setImage(UIImage(named: "Like-Icon"), for: .normal)
        cutsomCell.shareButton.setImage(UIImage(named: "Share-Icon"), for: .normal)
        cutsomCell.portfolioButton.setImage(UIImage(named: "Portfolio-Off-Icon"), for: .normal)
        cutsomCell.watchlistButton.setImage(UIImage(named: "Watchlist-Off-Icon"), for: .normal)
        
        if let productMainImage = productObject.productMainImage{
            cutsomCell.productImageView.image = productMainImage
        }else{
            
            var imageNameKey = productObject.localImageUrl!.replacingOccurrences(of: " ", with: "_")
            imageNameKey = getImageNameFromURLString(urlString: imageNameKey)!
            let imagePath = fileInDocumentsDirectory(filename: "Image_\(imageNameKey)")
            
            if FileManager.default.fileExists(atPath: imagePath){
                print("Image loading from CACHE")
                let image = loadImageFromPath(path: imagePath)
                productObject.productMainImage = image
                cutsomCell.productImageView.image = image
            }else{
                print("Image doesnot exsist : \(indexPath.row) ID : \(productObject.id)")
                
                cutsomCell.productImageView.image = nil
                
                DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                    
                    var urlString = productObject.localImageUrl
                    urlString = urlString?.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
                    
                    do{
                        
                        let imageData = try Data(contentsOf:URL(string: urlString!)!)
                        DispatchQueue.main.async {
                            
                            let image = UIImage(data: imageData)
                            productObject.productMainImage = image
                            cutsomCell.productImageView.image = image
                            
                        }
                    }catch{
                        
                    }
                }
            }
        }
        
        if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: productObject.id){
            
            productObject.productLiked(isLiked: (productInfo.isLiked?.boolValue)!)
            productObject.isShared = productInfo.isShared?.boolValue ?? false
            productObject.userRated = productInfo.isRated?.boolValue ?? false
            productObject.isAddedToPortfolio = productInfo.isAddedToPortfolio?.boolValue ?? false
            productObject.isAddedToWatchList = productInfo.isAddedToWishList?.boolValue ?? false
            
            if productObject.isShared == true{
                cutsomCell.shareButton.setImage(UIImage(named: "share-selected"), for: .normal)
            }else{
                cutsomCell.shareButton.setImage(UIImage(named: "Share-Icon"), for: .normal)
            }
            
            if productObject.isLiked == true{
                cutsomCell.likeButton.setImage(UIImage(named: "like-selected"), for: .normal)
            }else{
                cutsomCell.likeButton.setImage(UIImage(named: "Like-Icon"), for: .normal)
            }
            
            if productObject.isAddedToPortfolio == true{
                cutsomCell.portfolioButton.setImage(UIImage(named: "Portfolio-On-Icon-1"), for: .normal)
            }else{
                cutsomCell.portfolioButton.setImage(UIImage(named: "Portfolio-Off-Icon"), for: .normal)
            }
            
            if productObject.isAddedToWatchList == true{
                cutsomCell.watchlistButton.setImage(UIImage(named: "Watchlist-On-Icon"), for: .normal)
            }else{
                cutsomCell.watchlistButton.setImage(UIImage(named: "Watchlist-Off-Icon"), for: .normal)
            }
            
        }
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-3{
            
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAt indexPath: NSIndexPath) {
        
        let cutsomCell : ProductListCell = cell as! ProductListCell
        
        cutsomCell.portfolioButton.setImage(UIImage(named: "Portfolio-Off-Icon"), for: .normal)
        cutsomCell.watchlistButton.setImage(UIImage(named: "Watchlist-Off-Icon"), for: .normal)
        
    }
}

extension ProductListViewController{
    
    func getImageNameFromURLString(urlString : String) -> String?{
        
        let slices = urlString.components(separatedBy: "/")
        return slices.last
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func fileInDocumentsDirectory(filename: String) -> String {
        
        let fileURL = getDocumentsDirectory().appendingPathComponent("ImageFolder").appendingPathComponent(filename)
        return fileURL.path
        
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        if image == nil {
            
            //print("missing image at: \(path)")
        }
        //print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }
    
}
