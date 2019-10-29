//
//  TimeLineViewController.swift
//  Swagafied
//
//  Created by Amitabha on 30/10/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit
import MBProgressHUD

class TimeLineViewController: BaseViewController {

    var productDetailAPI = ProductDetail()
    var timelineAPI = TimelineAPI()
    var dataSource : Array<TimelineProduct> = Array<TimelineProduct>()
    let likeProductAPIObject = LikeProductAPI()
    let unlikeProductAPIObject = UnlikeProductAPI()
    var selectedIndex: IndexPath!
    
    @IBOutlet weak var timelineTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let cellNib = UINib.init(nibName: Configuration.XIBNames.TimelineTableViewCell, bundle: Bundle.main)
        self.timelineTable.register(cellNib, forCellReuseIdentifier: Configuration.CellIdentifier.TimelineTableViewCell)
        
        self.shadowImageView.isHidden = false
        
        // Add like button to navigation bar as right item
        let filterButton = UIButton()
        filterButton.setImage(UIImage(named: "Menu-Icon"), for: .normal)
        self.navigationBar.addRightBarButtons(rightButtons: [filterButton])
        
        let timeLine = UIButton()
        timeLine.setImage(UIImage(named: "home_icon"), for: .normal)
        self.navigationBar.addLeftBarButton(leftButton: timeLine)
        
//        let backButton = UIButton()
//        backButton.setImage(UIImage(named: "Back-Arrow"), for: .normal)
//        self.navigationBar.addLeftBarButton(leftButton: backButton)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationBar.pageHeader = "What's Poppin?"
        
        getTimelineData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.bringSubview(toFront: self.navigationBar)
        self.view.bringSubview(toFront: self.shadowImageView)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationBar.pageHeader = "Swagafied"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTimelineData(){
        timelineAPI.didCompleteRequest = {
            [weak self] success in
            
            self!.processArrayAndDownloadImage(products: self!.timelineAPI.products)
        }
        
        let _ = NetworkManager.sharedManager.request(apiObject:timelineAPI)
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    func processArrayAndDownloadImage( products : Array<TimelineProduct> , setIndex : Bool = true ){
        
        let imageURLArray = products.map({ (productObject) -> String in
            return productObject.imageUrl!
        })
        
        let imageDownloaderManager = ImageDownloaderManager.sharedImageDownloaderManager
        imageDownloaderManager.mainImageURLs = imageURLArray
        
        // Define the indexes
        if setIndex{
            imageDownloaderManager.idx = 0
            imageDownloaderManager.downloadedIndex = 0
        }
        
        imageDownloaderManager.completionHandler = { (index,success) -> () in
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
            var products: Array<TimelineProduct> = products
            self.dataSource = Array(products[0...index])
            self.timelineTable.reloadData()
            
        }
        
        imageDownloaderManager.downloadNextSetImage()
        
    }
    
    func getPoductDetail( productid: String, completion: @escaping ((_ success: Bool)->())){
        
        productDetailAPI.productID = productid
        productDetailAPI.didCompleteRequest = { success in
            completion(success)
        }
        
        let _ = NetworkManager.sharedManager.request(apiObject:productDetailAPI)
    }
    
    func showProductDetailPage(){
        self.performSegue(withIdentifier: Configuration.SegueNames.ShowProductDetailViewControllerFromTimeline, sender: self)
    }
    
    //MARK:- Navigatin Bar Delegate -
    
    override func didSelectLeftButton(sender:UIButton) {

        let searchPage = loadViewControllerFromStroryboard(storyboard: Configuration.Storyboard.MainStoryBoard, viewControllerIndentifier:Configuration.ViewControllers.ProductListViewController) as! ProductListViewController
        let navc = UINavigationController(rootViewController: searchPage)
        navc.setNavigationBarHidden(true, animated: false)
        WindowManager.sharedManager.setViewController(selectedViewController: navc)
        
    }
    
    override func didSelectRightButton(sender:UIButton) {
        WindowManager.sharedManager.showMenu()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Configuration.SegueNames.ShowPortfolioViewControllerFromTimeline{
            let destinationVC : PortfolioListViewController = segue.destination as! PortfolioListViewController
            destinationVC.fromTimeLine = true
            let selectedIndex = sender as! NSIndexPath
            let dtsurce : TimelineProduct = dataSource[selectedIndex.row] as TimelineProduct
            destinationVC.userIDForPortfolio = dtsurce.userId
        }
        
        else if segue.identifier == Configuration.SegueNames.ShowProductDetailViewControllerFromTimeline{
            
            let cell : TimelineTableViewCell  = timelineTable.cellForRow(at: selectedIndex) as! TimelineTableViewCell
            let destinationVC : ProductDetailViewController = segue.destination as! ProductDetailViewController
            destinationVC.dataModel = productDetailAPI.product
            destinationVC.dataModel?.productMainImage = cell.cellImageView.image
            
            if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: (productDetailAPI.product?.id)! ){
                destinationVC.dataModel?.productLiked(isLiked: (productInfo.isLiked?.boolValue)!)
                destinationVC.dataModel?.addToPortfolio(isAdded: (productInfo.isAddedToPortfolio?.boolValue)!)
                destinationVC.dataModel?.addToWatchList(isAdded: (productInfo.isAddedToWishList?.boolValue)!)
                destinationVC.dataModel?.isShared = (productInfo.isShared?.boolValue)!
            }
        }
    }
}

// MARK: - TableView Delegate
extension TimeLineViewController : UITableViewDelegate{
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("did end dragging ")
        
        if !decelerate {
        
        }
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 500.0 {
            self.processArrayAndDownloadImage(products: dataSource,setIndex: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: Configuration.SegueNames.ShowPortfolioViewControllerFromTimeline, sender: indexPath)
    }
    
}

// MARK: - TableView DataSource
extension TimeLineViewController : UITableViewDataSource{
    
    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Configuration.Sizes.TimelineTableCellHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TimelineTableViewCell = tableView.dequeueReusableCell(withIdentifier: Configuration.CellIdentifier.TimelineTableViewCell, for: indexPath) as! TimelineTableViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        cell.selectionStyle = .none
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Configuration.NavigationBar.NavigationBarHeight-20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cutsomCell : TimelineTableViewCell = cell as! TimelineTableViewCell
        let productObject : TimelineProduct = dataSource[indexPath.row]
        
        cutsomCell.userNameLabel.text = getActionString(data: productObject)
        cutsomCell.descriptionLabel.text = productObject.lastReview
        cutsomCell.totalLikesLabel.text = " \(productObject.likes!) Likes"
        
        var imageNameKey = productObject.imageUrl!.replacingOccurrences(of: " ", with: "_")
        imageNameKey = getImageNameFromURLString(urlString: imageNameKey)!
        let imagePath = fileInDocumentsDirectory(filename: "Image_\(imageNameKey)")
        
        if FileManager.default.fileExists(atPath: imagePath){
            print("Image loading from CACHE")
            let image = loadImageFromPath(path: imagePath)
            cutsomCell.cellImageView.image = image
        }else{
            print("Image doesnot exsist : \(indexPath.row) URL : \(productObject.imageUrl)")
            
            // Product Image
            let urlString = (self.dataSource[indexPath.row].imageUrl)!.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: urlString!)
            
            ImageDownloaderManager.sharedImageDownloaderManager.downloadImage(url: url!, indexpath: indexPath , completionBlock: { (image, success) in
                if success {
                    cutsomCell.cellImageView.image = image
                }
            })
        }
        
        // User Profile Picture
        let userProfilePicurlString = (self.dataSource[indexPath.row].userProfilePicUrl)?.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        
        if let urlstring = userProfilePicurlString{
            
            let urlProfilePic = URL(string: urlstring)
            
            if let profilePicURL = urlProfilePic{
                ImageDownloaderManager.sharedImageDownloaderManager.downloadImage(url: profilePicURL, indexpath: indexPath , completionBlock: { (image, success) in
                    if success {
                        cutsomCell.userAvatarImageView.contentMode = .scaleAspectFill
                        cutsomCell.userAvatarImageView.image = image
                        cutsomCell.userAvatarImageView.layer.cornerRadius = 22.0
                        cutsomCell.userAvatarImageView.clipsToBounds = true
                    }
                })
            }
        }
        
        
    
        if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: productObject.productId!){
            if productInfo.isLiked?.boolValue == true{
                cutsomCell.likesButton.setImage(UIImage(named: "like-selected"), for: .normal)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cutsomCell : TimelineTableViewCell = cell as! TimelineTableViewCell
        cutsomCell.cellImageView.image = nil
        cutsomCell.likesButton.setImage(UIImage(named: "Like-Icon"), for: .normal)
        cutsomCell.userAvatarImageView.image = UIImage(named: "addAvatar")
        cutsomCell.userAvatarImageView.contentMode = .scaleAspectFit
        cutsomCell.userAvatarImageView.clipsToBounds = false
    }
    
    //MARK: - Private methods
    
    func getActionString(data: TimelineProduct) -> String{
        
        var username = ""
        var actionTitle = ""
        
        if let email = data.email
        {
            let x = email.components(separatedBy: "@")
            let y = x[1].components(separatedBy: ".")
            
            username = (data.userName?.characters.count)! > 0 ? data.userName! : x[0]+"_"+y[0]
            
            switch (data.actionId)! {
            case "1":
                actionTitle = "\n Admin Just added these kicks"
                break
            case "2":
                actionTitle = "\nJust liked these kicks"
                break
            case "3":
                 actionTitle = "\nJust reviewed these kicks"
                break
            case "4":
                actionTitle = "\nJust gave these kicks a 5 star Review"
                break
            case "5":
                actionTitle = "\nJust added these kicks to his portfolio"
                break
            case "6":
                actionTitle = "\nJust added these kicks to his watchlist"
                break
                
            default:
                break
                
            }
        }
    
        return username+actionTitle
    }
    
    func getActionString(){
        
    }
}

extension TimeLineViewController : TimelineTableViewCellDelegate{
    
    func likeButtonToogleActionn(indexPath: IndexPath, button: UIButton) {
        
        let productObject = self.dataSource[indexPath.row]
        let productListCell : TimelineTableViewCell = self.timelineTable.cellForRow(at: indexPath as IndexPath) as! TimelineTableViewCell
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        self.likeProductAPIObject.didCompleteRequest = { [weak self] success in
            productListCell.isLiked = true
            MBProgressHUD.hide(for: self!.view, animated: true)
            if(success){
                
                productObject.likes = "\(Int(productObject.likes!)! + 1)"
                productListCell.totalLikesLabel.text = " \(productObject.likes!) Likes"
                productListCell.likesButton.setImage(UIImage(named: "like-selected"), for: .normal)
                
                if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: productObject.productId!){
                    
                    let itemModel  = ItemModel(product: productInfo)
                    itemModel.ItemIsLiked = true
                    DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                    
                }else{
                    
                    let itemModel : ItemModel = ItemModel()
                    itemModel.ItemId = productObject.productId!
                    itemModel.ItemIsLiked = true
                    DatabaseHelper.sharedHelper.insertItem(item: itemModel)
                    
                }
                
            }else{
                
            }
        }
        
        self.unlikeProductAPIObject.didCompleteRequest = { [weak self] success in
            MBProgressHUD.hide(for: self!.view, animated: true)
            if(success){
                productListCell.isLiked = false
                productObject.likes = "\(Int(productObject.likes!)! - 1)"
                productListCell.totalLikesLabel.text = " \(productObject.likes!) Likes"
                productListCell.likesButton.setImage(UIImage(named: "Like-Icon"), for: .normal)
                
                if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: productObject.productId!){
                    
                    let itemModel  = ItemModel(product: productInfo)
                    itemModel.ItemIsLiked = false
                    DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                    
                }
                
            }else{
                
            }
        }
        
        if productListCell.isLiked {
            let _ = NetworkManager.sharedManager.request(apiObject:self.unlikeProductAPIObject)
        }else{
            let _ = NetworkManager.sharedManager.request(apiObject:self.likeProductAPIObject)
        }
        
    }
    
    func didSelectInfoButtonn(indexPath: IndexPath) {
        
        let productObject = self.dataSource[indexPath.row]
        let _ = getPoductDetail(productid: productObject.productId!, completion: {
            (success: Bool) in
            
            self.selectedIndex = indexPath
            self.showProductDetailPage()
            
        })
        
    }
    
    func didSelectShareButtonn(indexPath: IndexPath, button: UIButton) {
        
        let cell : TimelineTableViewCell  = timelineTable.cellForRow(at: indexPath) as! TimelineTableViewCell
        let productObject : TimelineProduct = dataSource[indexPath.row]
        
        let text = "Find Lit Kicks @Swagafied. Download the app"
        if let image = cell.cellImageView.image {
            
            let vc = UIActivityViewController(activityItems: [image,text], applicationActivities: [])
            self.present(vc, animated: true, completion: nil)
            
            vc.completionWithItemsHandler = { (activityType, completed , returnedItems, error) -> Void in
                
                if error == nil && completed{
                    
                    // Call Share API here
                    cell.shareButton.setImage(UIImage(named: "share-selected"), for: .normal)
                    
                    if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: productObject.productId!){
                        
                        let itemModel  = ItemModel(product: productInfo)
                        itemModel.ItemIsShared = true
                        DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                        
                    }else{
                        
                        let itemModel : ItemModel = ItemModel()
                        itemModel.ItemId = productObject.productId!
                        itemModel.ItemIsShared = true
                        DatabaseHelper.sharedHelper.insertItem(item: itemModel)
                        
                    }
                    
                }
            }
            
        }else{
            // Image not found
            
        }
        
    }
    
    func didSelectAllCommentsButtonn(indexPath: IndexPath) {
       
        let productObject = self.dataSource[indexPath.row]
        let _ = getPoductDetail(productid: productObject.productId!, completion: {
            (success: Bool) in
            
            let messageVC : MessagesViewController = self.loadViewControllerFromStroryboard(storyboard: Configuration.Storyboard.MainStoryBoard, viewControllerIndentifier: Configuration.StoryboardVC.MessagesViewController) as! MessagesViewController
        
            messageVC.showReview = false
            messageVC.dataModel = self.productDetailAPI.product
            let cell : TimelineTableViewCell  = self.timelineTable.cellForRow(at: indexPath) as! TimelineTableViewCell
            messageVC.dataModel?.productMainImage = cell.cellImageView.image
            self.navigationController?.pushViewController(messageVC, animated: true)
            
        })
    }
    
}

extension TimeLineViewController{
    
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
            
            print("missing image at: \(path)")
        }
        print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }
}
