//
//  CountyPicker.swift
//  Swagafied
//
//  Created by Amitabha on 14/01/17.
//  Copyright © 2017 Amitabha Saha. All rights reserved.
//

import UIKit
import SwiftyJSON

class CountyPicker: UIView,UITableViewDelegate,UITableViewDataSource {
    
    var navigationbar: UIView!
    let cellIdentifier = "plainTableViewCell"
    var dataModel: StatesCountyModel = StatesCountyModel()
    var tableView: UITableView!
    
    var cancelCallBack: (()->())!
    var selectionCallBack: ((String,String)->())!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        arrangeInitialView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        arrangeInitialView()
    }
    
    func arrangeInitialView(){
        
        dataModel.loadDataSource {

            self.navigationbar = UIView() 
            self.navigationbar.backgroundColor = UIColor(netHex: 0x37C283)
            self.navigationbar.frame = CGRect(x: 50, y: 64, width: self.frame.size.width-100 , height:  44)
            
            // Add like button to navigation bar as left item
            let cancelButton = UIButton()
            cancelButton.backgroundColor = UIColor.clear
            cancelButton.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.setTitleColor(UIColor.white , for: .normal)
            cancelButton.addTarget(self, action: #selector(self.cancelButtonAction), for: .touchUpInside)
            self.navigationbar.addSubview(cancelButton)
            
            if self.tableView == nil{
                self.tableView = UITableView(frame: CGRect(x: 50, y: 108, width: self.frame.size.width-100 , height: self.frame.size.height - 172), style: .grouped)
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.addSubview(self.tableView)
            }
            
            self.addSubview(self.navigationbar)
            self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
    @objc func cancelButtonAction(){
        if let cancel = cancelCallBack{
            cancel()
        }
        
    }
    
    //MARK:- TableView Delegate -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataModel.statesDictionary.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data =  dataModel.statesDictionary[section]
        return data.1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
        cell.textLabel?.textColor = UIColor.black
        let data =  dataModel.statesDictionary[indexPath.section]
        let county: JSON = data.1[indexPath.row] as! JSON
        cell.textLabel?.text = county.stringValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let data =  dataModel.statesDictionary[section]
        return data.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data =  dataModel.statesDictionary[indexPath.section]
        let state = data.0
        let county: JSON = data.1[indexPath.row] as! JSON
        
        if let selection = selectionCallBack{
            selection(state,county.stringValue)
        }
        
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
