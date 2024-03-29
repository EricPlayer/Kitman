//
//  PortfolioListViewController.swift
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

class PortfolioListViewController: BaseViewController {

    var fromTimeLine: Bool = false
    var userIDForPortfolio : String!
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    let itemsPerRow: CGFloat = 2
    var productDetail: PortfolioProductDetailViewController!
    let portfoliotListApiObject = ProtfolioListAPI()
    var dataSource : Array<Portfoliolist> = Array<Portfoliolist>(){
        didSet{
            
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    let reuseIdentifier = "kicksCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add like button to navigation bar as right item
        let filterButton = UIButton()
        filterButton.setImage(UIImage(named: "Menu-Icon"), for: .normal)
        
        let timeLine = UIButton()
        timeLine.setImage(UIImage(named: "home_icon"), for: .normal)
        self.navigationBar.addLeftBarButton(leftButton: timeLine)
        
        self.navigationBar.addRightBarButtons(rightButtons: [filterButton])
        self.shadowImageView.isHidden = false
        
        productDetail = loadViewControllerFromStroryboard(storyboard: Configuration.Storyboard.MainStoryBoard, viewControllerIndentifier: Configuration.ViewControllers.PortfolioProductDetailViewController) as! PortfolioProductDetailViewController
        
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.view.bringSubview(toFront: self.navigationBar)
            self.view.bringSubview(toFront: self.shadowImageView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getProductLists()
    }
    
    func getProductLists(){
        
        if let userID = userIDForPortfolio{
            portfoliotListApiObject.dafaultUserID = userID
        }
        
        portfoliotListApiObject.didCompleteRequest = { [weak self] success in
            MBProgressHUD.hide(for: self!.view, animated: true)
            if(success){
                self!.portfoliotListApiObject.products.sort(by: { $0.productId! < $1.productId! })
                self!.dataSource = self!.portfoliotListApiObject.products
                self!.collectionView.reloadData()
            }else{
                self!.dataSource = Array<Portfoliolist>()
                self!.collectionView.reloadData()
            }
        }
        
        let _ = NetworkManager.sharedManager.request(apiObject:portfoliotListApiObject)
        
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationBar.pageHeader = "Portfolio"
        
        
        
        if let _ = userIDForPortfolio{
            
            let backButton = UIButton()
            backButton.setImage(UIImage(named: "Back-Arrow"), for: .normal)
            self.navigationBar.addLeftBarButton(leftButton: backButton)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                self.setbottomView()
            }
        }
        
        self.dataSource = Array<Portfoliolist>()
        self.collectionView.reloadData()
    }
    
    func setbottomView(){
        
        let bottomView = OthersPortfolioBottomView()
        self.view.addSubview(bottomView)
        
        bottomView.autoPinEdge(.leading, to: .leading, of: self.view, withOffset: 0)
        bottomView.autoPinEdge(.trailing , to: .trailing, of: self.view, withOffset: 0)
        bottomView.autoPinEdge(.bottom , to: .bottom, of: self.view, withOffset: 0)
        bottomView.autoSetDimension(.height, toSize: 50)
    }
    
    //MARK:- Navigationbar Delegate
    override func didSelectLeftButton(sender: UIButton) {
        
        if fromTimeLine == true{
            let _ = self.navigationController?.popViewController(animated: true)
        }else{
            let searchPage = loadViewControllerFromStroryboard(storyboard: Configuration.Storyboard.MainStoryBoard, viewControllerIndentifier:Configuration.ViewControllers.ProductListViewController) as! ProductListViewController
            let navc = UINavigationController(rootViewController: searchPage)
            navc.setNavigationBarHidden(true, animated: false)
            WindowManager.sharedManager.setViewController(selectedViewController: navc)
        }
    }
    
    override func didSelectRightButton(sender: UIButton) {
        WindowManager.sharedManager.showMenu()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == Configuration.SegueNames.ShowPoftfolioProductDetailViewController){
            
            let index = collectionView.indexPathsForSelectedItems?.last
            let portfolioDetail : PortfolioProductDetailViewController = segue.destination as! PortfolioProductDetailViewController
            portfolioDetail.dataModelPortfolio = dataSource[(index?.row)!]
            
            if let _ = userIDForPortfolio{
                productDetail.source = .portfolio
            }
            
        }
    }
    
}
// cellForItemAtIndexPath(

extension PortfolioListViewController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell :PhotoCollectionViewCell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        productDetail.dataModelPortfolio = dataSource[(indexPath.row)]
        productDetail.productImage = cell.imageview.image ?? nil
        if let _ = userIDForPortfolio{
            productDetail.source = .portfolio
        }
        self.navigationController?.pushViewController(productDetail, animated: true)
        
//        performSegueWithIdentifier(Configuration.SegueNames.ShowPoftfolioProductDetailViewController, sender: self)
    }
}

extension PortfolioListViewController : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PhotoCollectionViewCell
        
        let urlString = (self.dataSource[indexPath.row].imageUrl)!.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlString!)
        cell.activityIndicatior.startAnimating()
        
        cell.imageview.image = nil
        ImageDownloaderManager.sharedImageDownloaderManager.downloadImage(url: url!, completionBlock: { (image, success) in
            if success {
                cell.imageview.image = image
                cell.activityIndicatior.stopAnimating()
                cell.activityIndicatior.isHidden = true
            }
        })
        
        cell.layoutIfNeeded()
        // Configure the cell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "colectionHeader", for: indexPath)
            return headerView
        default:
            let headerView =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "colectionHeader", for: indexPath)
            return headerView
        }
    }
}


