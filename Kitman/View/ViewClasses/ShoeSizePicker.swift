//
//  ShoeSizePicker.swift
//  Swagafied
//
//  Created by Amitabha on 06/11/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShoeSizePicker: UIView,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var masterTableView: UITableView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var shoePriceTextField: UITextField!
    
    let fileName = "ShoeSize"
    let cellIdentifier = "plainTableViewCell"
    var shoePrice : String!
    var cancelActionCompletionHandler  : (()->())!
    var selectActionCompletionHandler  : ((_ selectedID : String, _ selctedSize: String, _ price : String)->())!
    var detailTableSelectedRow = 0
    var masterTableSelectedRow = 0
    var masterTableDataSource : Array<String>!
    var detailTableDataSource : Array<Array<(String,String)>>!
    
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
        let nib = UINib(nibName: Configuration.XIBNames.ShoeSizePicker , bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        
        self.shoePriceTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        self.shoePriceTextField.becomeFirstResponder()
        
        self.parentView.layer.cornerRadius = 5
        self.parentView.layer.borderWidth = 0.5
        self.parentView.layer.borderColor = UIColor.gray.cgColor
        self.parentView.clipsToBounds = true
        
        self.masterTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.detailTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        loadDataSource()
    }
    
    func loadDataSource(){
        
        // Load data from local json file & configure data source
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
    
            do {
                
                // Load Data type object from local json file
                let data = try NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                
                
                // Serialize data object into JSON object
                let jsonObj = JSON(data: data as Data)
                
                
                // Check for valid data
                if jsonObj != JSON.null {
                    
                    
                    // Configure master Table datasource
                    masterTableDataSource = jsonObj["shoe_size_list"].arrayValue.map({$0["type_name"].stringValue})
                    
                    
                    // Configure detail table datasource
                    let sizeObject = jsonObj["shoe_size_list"].arrayValue.map({$0["shoe_size"].arrayValue})
                    detailTableDataSource = sizeObject.map({$0.map({
                        ($0["size_id"].stringValue,$0["us_size"].stringValue)
                    })})
                    
                } else {
                    print("could not get json from file, make sure that file contains valid json.")
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        } else {
            print("Invalid filename/path.")
        }
    }

    @IBAction func cancelButtonAction(_ sender: AnyObject) {
        
        self.removeFromSuperview()
        if let completion = cancelActionCompletionHandler{
            completion()
        }
    }

    @IBAction func doneButtonAction(_ sender: AnyObject) {
        
        let sizeID = detailTableDataSource[masterTableSelectedRow][detailTableSelectedRow].0
        let size = detailTableDataSource[masterTableSelectedRow][detailTableSelectedRow].1
        
        if let completion = selectActionCompletionHandler, let shoePrice = shoePrice{
            completion(sizeID, size, shoePrice)
            self.removeFromSuperview()
        }else{
            
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = textField.text?.currencyInputFormatting() {
            self.shoePriceTextField.text = amountString
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        shoePrice = textField.text!.replacingOccurrences(of: " ", with: "")
        shoePrice = shoePrice.replacingOccurrences(of: "$", with: "")
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == masterTableView{
            masterTableSelectedRow = indexPath.row
            detailTableView.reloadData()
        }else{
            detailTableSelectedRow = indexPath.row
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
        cell.textLabel?.textColor = UIColor.black
        
        self.shoePriceTextField.resignFirstResponder()
        
        if tableView == masterTableView{
            cell.textLabel!.text = masterTableDataSource[indexPath.row]
        }else{
            cell.textLabel!.text = detailTableDataSource[masterTableSelectedRow][indexPath.row].1
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == masterTableView{
            return masterTableDataSource.count
        }else{
            return detailTableDataSource[masterTableSelectedRow].count
        }
    }
}

extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        if #available(iOS 9.0, *) {
            formatter.numberStyle = .currencyAccounting
        } else {
            // Fallback on earlier versions
        }
        formatter.currencySymbol = " $ "
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}
