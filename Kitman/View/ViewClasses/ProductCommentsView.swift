//
//  ProductCommentView.swift
//  Swagafied
//
//  Created by Amitabha on 22/01/17.
//  Copyright © 2017 Amitabha Saha. All rights reserved.
//

import UIKit

class ProductCommentsView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var productID: String!
    let postCommentAPI = PostCommentAPI()
    let allCommentList = AllCommentList()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    var messageList : Array<Comment> = Array<Comment>(){
        didSet{
            if messageList.count > 0{
                
                self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
                self.tableView.estimatedRowHeight = 10
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.separatorColor = UIColor.clear
                
                self.tableView.reloadData()
            }
        }
    }
    
    let cellIdentifier = "plainTableViewCell"
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: Configuration.XIBNames.ProductCommentsView , bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);

    }
    
    func loadDataSource(){
        
        allCommentList.productID = productID
        
        allCommentList.didCompleteRequest = { (success:Bool) in
            if self.allCommentList.success == false{
                
            }else{
                self.messageList = self.allCommentList.collections
            }
        }
        
        let _ = NetworkManager.sharedManager.request(apiObject:allCommentList)
        
    }

    @IBAction func postButtonAction(_ sender : UIButton){
        
        postCommentAPI.comemnt = commentTextField.text ?? ""
        postCommentAPI.productID = productID
        
        postCommentAPI.didCompleteRequest = { (success: Bool) in
            if success{
                
                if let productInfo = DatabaseHelper.sharedHelper.fetchItemForID(id: self.productID){
                    
                    let itemModel  = ItemModel(product: productInfo)
                    itemModel.ItemIsMessaged = true
                    DatabaseHelper.sharedHelper.updateItem(item: itemModel)
                    
                }else{
                    
                    let itemModel : ItemModel = ItemModel()
                    itemModel.ItemId = self.productID
                    itemModel.ItemIsMessaged = true
                    DatabaseHelper.sharedHelper.insertItem(item: itemModel)
                    
                }
                
                self.loadDataSource()
                
            }else{
                
            }
        }
        
        if postCommentAPI.comemnt.characters.count > 0{
            
            let _ = NetworkManager.sharedManager.request(apiObject:postCommentAPI)
            commentTextField.text = ""
            commentTextField.resignFirstResponder()
        }else{
            
//            let alert = UIAlertController(title: "Error", message: "Enter your comment" , preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alertAction) -> Void in
//            }))
//            
//            self.present(alert, animated: true, completion:nil)
        }
        
    }
    
    @IBAction func cancelButtonAction(_ sender : UIButton){
        self.removeFromSuperview()
    }
    
    //MARK: - Tableview Delegate - 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        
        cell.selectionStyle = .none
        
        let attributes: [NSAttributedStringKey: Any] = [
            .font : UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium),
            .foregroundColor : UIColor.darkGray
        ]
        let userNameString = NSAttributedString(
            string: getUserNameFromEmail(email: messageList[indexPath.row].email!)!,
//            attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium), NSForegroundColorAttributeName : UIColor.darkGray]
            attributes: attributes
        )
        
        let attributes2: [NSAttributedStringKey: Any] = [
            .font : UIFont.italicSystemFont(ofSize: 12),
            .foregroundColor : UIColor.lightGray
        ]
        let commentString = NSAttributedString(
            string: " \n  \n \(messageList[indexPath.row].message!) \n",
//            attributes: [NSFontAttributeName:UIFont.italicSystemFont(ofSize: 12), NSForegroundColorAttributeName : UIColor.lightGray]
            attributes: attributes2
        )
        
        let concate = NSMutableAttributedString(attributedString: userNameString)
        concate.append(commentString)
        
        cell.textLabel?.attributedText = concate
        cell.textLabel?.textColor = UIColor.gray
        
//        cell.detailTextLabel?.text  = messageList[indexPath.row].message
//        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    // MARK: - Private Functions -
    private func getUserNameFromEmail(email: String) -> String? {
        
        let x = email.components(separatedBy: "@")
        let y = x[1].components(separatedBy: ".")
        
        let username = x[0]+"_"+y[0]
        return username
    }

}
