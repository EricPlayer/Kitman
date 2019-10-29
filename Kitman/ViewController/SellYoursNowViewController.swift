//
//  SellYoursNowViewController.swift
//  Swagafied
//
//  Created by Amitabha on 24/07/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit
import JSSAlertView

class SellYoursNowViewController: BaseViewController {
    
    var dataModel : ProductObject?
    var timer : Timer?
    
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minsLabel: UILabel!
    @IBOutlet weak var secsLabel: UILabel!
    
    @IBOutlet weak var informMeLabel: UILabel!
    
    
    @IBOutlet weak var notifyMeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.notifyMeButton.layer.borderWidth = kSinglePixelWidth
        self.notifyMeButton.layer.borderColor = kOrangeColor.cgColor
        self.notifyMeButton.layer.cornerRadius = 7
        
        // Add like button to navigation bar as left item
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "Back-Arrow"), for: .normal)
        self.navigationBar.addLeftBarButton(leftButton: backButton)

        // Do any additional setup after loading the view.
    
    }
    
    @objc func update(){
        
        let launchDate = Utility.getLaunchDate()
        
        daysLabel.text = "\(Date().daysBeforeDate(launchDate!))"
        hoursLabel.text = "\(Date().hoursBeforeDate(launchDate!)%24)"
        minsLabel.text = "\(Date().minutesBeforeDate(launchDate!)%60)"
        secsLabel.text = "\(Date().secondsBeforeDate(launchDate!)%60)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        update()
        
        if (timer == nil){
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        }
        
        if let dataModel = self.dataModel{
            
            self.productNameLabel.text = dataModel.productName
            productDescriptionLabel.adjustsFontSizeToFitWidth = true
            
            if let date  = DateTimeFormatter.sharedFormatter.convertStringToDate(dateString: dataModel.productReleaseDate!) {
                self.productDescriptionLabel.text = "  Collection: \(dataModel.collectionName!)    Released: \(date.year())    Retail: $\(dataModel.retailPrice!)  "
            }else{
                self.productDescriptionLabel.text = "  Collection: \(dataModel.collectionName!)    Released:     Retail: $\(dataModel.retailPrice!)  "
            }
        }
        
        if UserDefaults.standard.bool(forKey: Configuration.UserDefaultKeys.IsNotified){
            
            notifyMeButton.isHidden = true
            informMeLabel.text = "Thanks! We'll hit you up the moment this feature is available."
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    
    @IBAction func notifyButtonAction(_ sender: AnyObject) {
        
        loginCallBackAction(success: {
            
            self.informMeLabel.text = "Thanks! We'll hit you up the moment this feature is available."
            self.notifyMeButton.isHidden = true
            UserDefaults.standard.set(true, forKey: Configuration.UserDefaultKeys.IsNotified)
            
            }) { 
                
                JSSAlertView().danger((sharedAppDelegate.window?.rootViewController)!, title: "Info", text: "Sorry, Login failed")
        }
    }
    
    //MARK:- Navigatin Bar Delegate -
    
    override func didSelectLeftButton(sender:UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didSelectRightButton(sender:UIButton) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
