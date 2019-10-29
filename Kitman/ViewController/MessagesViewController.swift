//
//  MessagesViewController.swift
//  Swagafied
//
//  Created by Amitabha on 23/07/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit
import MBProgressHUD

class MessagesViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,MessagesTableViewCellDelegate {

    // Comment API's
    let likeCommentAPI = LikeCommentAPI()
    let reportCommentAPI = ReportCommentAPI()
    let postCommentAPI = PostCommentAPI()
    let allCommentList = AllCommentList()
    
    // Review API's
    let likeReviewAPI = LikeReviewAPI()
    let reportReviewAPI = ReportReviewAPI()
    let postReviewAPI = PostReviewAPI()
    let allReviewList = AllReviewList()
    
    var showReview: Bool = true
    @IBOutlet weak var sidePanelView: UIView!
    @IBOutlet weak var messageListTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    
    var productRatingView: ProductRating!
    
    var messageList : Array<Comment> = Array<Comment>(){
        didSet{
            self.messageListTableView.reloadData()
        }
    }
    var dataModel : ProductObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageListTableView.estimatedRowHeight = Configuration.Sizes.MessagesTableCellHeight
        messageListTableView.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
        
        let scaleDownFactor : CGFloat = 0.8
        
        productRatingView = ProductRating()
        productRatingView.frame = CGRect(x: 5 - CGFloat((150 * (1.0 - scaleDownFactor))/2), y: 200, width: 150, height: 30)
        productRatingView.rating = (dataModel?.productRating)!
        productRatingView.totalRating = (dataModel?.totalRating)!
        self.view.addSubview(productRatingView)
        let transform: CGAffineTransform = CGAffineTransform(scaleX: scaleDownFactor, y: scaleDownFactor)
        productRatingView.transform = transform
        
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "White-Arrow"), for: .normal)
        self.navigationBar.addLeftBarButton(leftButton: backButton)
        
        self.navigationBar.backgroundColor = kDarkColor
        self.navigationBar.appNameLabel?.text = showReview == true ? "Product Reviews" : "Product Comments"
        self.navigationBar.appNameLabel?.textColor = kWhiteColor
        self.navigationBar.appNameLabel?.font = Configuration.NavigationBar.NavigationBarNormalFont
        
        postButton.addTarget(self, action: #selector(self.postCommentAction(sender:)), for: .touchUpInside)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        reloadReviewData()
    }
    
    func reloadReviewData(){
        
        if showReview{
            
            allReviewList.productID = (dataModel?.id)!
            allReviewList.didCompleteRequest = { (success:Bool) in
                if self.allReviewList.success == false{
                    
                }else{
                    self.messageList = self.allReviewList.collections
                    if self.messageList.count == 0{
                        
                    }else{
                        self.messageListTableView.reloadData()
                    }
                }
            }
            
            let _ = NetworkManager.sharedManager.request(apiObject:allReviewList)
            
        }
        else{
            
            allCommentList.productID = (dataModel?.id)!
            allCommentList.didCompleteRequest = { (success:Bool) in
                if self.allCommentList.success == false{
                    
                }else{
                    self.messageList = self.allCommentList.collections
                    if self.messageList.count == 0{
                        
                    }else{
                        self.messageListTableView.reloadData()
                    }
                }
            }
            
            let _ = NetworkManager.sharedManager.request(apiObject:allCommentList)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        productImageView.image = dataModel?.productMainImage
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        setToDefaultNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func postCommentAction(sender:UIButton){
        
        if showReview{
            
            postReviewAPI.review = messageTextField.text ?? ""
            postReviewAPI.productID = (dataModel?.id)!
            
            postReviewAPI.didCompleteRequest = { (success: Bool) in
                if success{
                    
                    if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: (self.dataModel?.id)!){
                        
                        let itemModel  = ItemModel(product: productInfo)
                        itemModel.ItemIsMessaged = true
                        DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                        
                    }else{
                        
                        let itemModel : ItemModel = ItemModel()
                        itemModel.ItemId = (self.dataModel?.id)!
                        itemModel.ItemIsMessaged = true
                        DatabaseHelper.sharedHelper.insertItem(item: itemModel)
                        
                    }
                    
                    self.reloadReviewData()
                    
                }else{
                    
                }
            }
            
            if postReviewAPI.review.characters.count > 0{
                
                let _ = NetworkManager.sharedManager.request(apiObject:postReviewAPI)
                messageTextField.text = ""
                messageTextField.resignFirstResponder()
            }
            else{
                
                let alert = UIAlertController(title: "Error", message: "Enter your review" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alertAction) -> Void in
                }))
                
                self.present(alert, animated: true, completion:nil)
            }
            
        }
        else{
            
            postCommentAPI.comemnt = messageTextField.text ?? ""
            postCommentAPI.productID = (dataModel?.id)!
            
            postCommentAPI.didCompleteRequest = { (success: Bool) in
                if success{

                    self.reloadReviewData()
                }else{
                    
                }
            }
            
            if postCommentAPI.comemnt.characters.count > 0{
                
                let _ = NetworkManager.sharedManager.request(apiObject:postCommentAPI)
                messageTextField.text = ""
                messageTextField.resignFirstResponder()
            }
            else{
                
                let alert = UIAlertController(title: "Error", message: "Enter your comment" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alertAction) -> Void in
                }))
                
                self.present(alert, animated: true, completion:nil)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (messageList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessagesTableViewCell = tableView.dequeueReusableCell(withIdentifier: Configuration.CellIdentifier.MessagesTableViewCell, for: indexPath) as! MessagesTableViewCell
        cell.delegate = self
        cell.selectionStyle = .none;
        cell.commentLabel.text = messageList[indexPath.row].message
        cell.index = indexPath
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let tableCell : MessagesTableViewCell = cell as! MessagesTableViewCell
        tableCell.likeButton.setTitle("\(messageList[indexPath.row].likes!) Likes", for: .normal)
        
        if messageList[indexPath.row].userName?.characters.count == 0{
            tableCell.userNameLabel.text = getUserNameFromEmail(email: (messageList[indexPath.row].email!))
        }else{
            tableCell.userNameLabel.text = messageList[indexPath.row].userName
        }
        
        if self.messageList[indexPath.row].liked == true{
            tableCell.tagButton.setImage(UIImage(named: "like-selected"), for: .normal)
        }
        
        if let date = convertDate(dateString: messageList[indexPath.row].time!){
            tableCell.dateTimeLabel.text = date
        }
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let tableCell : MessagesTableViewCell = cell as! MessagesTableViewCell
        tableCell.likeButton.setTitle("", for: .normal)
        
        tableCell.tagButton.setImage(UIImage(named: "Like-Icon"), for: .normal)
        
        if messageList[indexPath.row].userName?.characters.count == 0{
            tableCell.userNameLabel.text = ""
        }else{
            tableCell.userNameLabel.text = ""
        }
        
        if let _ = convertDate(dateString: messageList[indexPath.row].time!){
            tableCell.dateTimeLabel.text = ""
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
    
    // MARK: - NavigationBar Delegate
    override func didSelectLeftButton(sender:UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didSelectRightButton(sender:UIButton) {
        
    }
    
    // MARK: - MessagesTableViewCellDelegate
    func didSelectReportButton(index:IndexPath) {
        
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        if showReview{
            
            reportReviewAPI.reviewID = messageList[index.row].commentID!
            reportReviewAPI.didCompleteRequest = { (success: Bool) in
                
                let alert = UIAlertController(title: "Success", message: "User review reported" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alertAction) -> Void in
                }))
                
                self.present(alert, animated: true, completion:{
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                })
                
            }
            
            let _ = NetworkManager.sharedManager.request(apiObject: reportReviewAPI)
            
        }
        else{
            
            reportCommentAPI.commentID = messageList[index.row].commentID!
            reportCommentAPI.didCompleteRequest = { (success: Bool) in
                
                let alert = UIAlertController(title: "Success", message: "User comment reported" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alertAction) -> Void in
                }))
                
                self.present(alert, animated: true, completion:{
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                })
                
            }
            
            let _ = NetworkManager.sharedManager.request(apiObject: reportCommentAPI)
            
        }
    }
    
    func didSelectLikeButton(index:IndexPath) {
        
        if showReview{
            
            likeReviewAPI.reviewID = messageList[index.row].commentID!
            likeReviewAPI.didCompleteRequest = { (success: Bool) in
                
                let cell : MessagesTableViewCell = self.messageListTableView.cellForRow(at: index) as! MessagesTableViewCell
                cell.tagButton.setImage(UIImage(named: "like-selected"), for: .normal)
                
                self.messageList[index.row].likes = Int(self.messageList[index.row].likes!) + 1
                cell.likeButton.setTitle(" \(self.messageList[index.row].likes!) Likes", for: .normal)
                self.messageList[index.row].liked = true
            }
            
            let _ = NetworkManager.sharedManager.request(apiObject: likeReviewAPI)
            
        }
        else{
            
            likeCommentAPI.commentID = messageList[index.row].commentID!
            likeCommentAPI.didCompleteRequest = { (success: Bool) in
                
                let cell : MessagesTableViewCell = self.messageListTableView.cellForRow(at: index) as! MessagesTableViewCell
                cell.tagButton.setImage(UIImage(named: "like-selected"), for: .normal)
                
                self.messageList[index.row].likes = Int(self.messageList[index.row].likes!) + 1
                cell.likeButton.setTitle(" \(self.messageList[index.row].likes!) Likes", for: .normal)
                self.messageList[index.row].liked = true
            }
            
            let _ = NetworkManager.sharedManager.request(apiObject: likeCommentAPI)
            
        }
    }
    
    // MARK: - Private methods
    private func convertDate(dateString: String) -> String?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm.ss"
        
        let dateObj = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "MM/dd/yy @ hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        if let date = dateObj{
            return dateFormatter.string(from: date)
        }else{
            return nil
        }
    }
    
    private func getUserNameFromEmail(email: String) -> String? {
      
        let x = email.components(separatedBy: "@")
        let y = x[1].components(separatedBy: ".")
        
        let username = x[0]+"_"+y[0]
        return username
    }
}
