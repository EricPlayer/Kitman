//
//  SellerViewController.swift
//  Swagafied
//
//  Created by Amitabha on 24/07/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

class SellerViewController: BaseViewController {

    var dataModel : ProductObject?
    
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productDetailTitleLabel: UILabel!
    @IBOutlet weak var sellYoursNowButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sellYoursNowButton.layer.borderWidth = kSinglePixelWidth
        self.sellYoursNowButton.layer.borderColor = kOrangeColor.cgColor
        self.sellYoursNowButton.layer.cornerRadius = 10
        
        // Add like button to navigation bar as left item
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "Back-Arrow"), for: .normal)
        self.navigationBar.addLeftBarButton(leftButton: backButton)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let dataModel = self.dataModel{
            
            self.productTitleLabel.text = dataModel.productName
            productDetailTitleLabel.adjustsFontSizeToFitWidth = true
            
            if let date  = DateTimeFormatter.sharedFormatter.convertStringToDate(dateString: dataModel.productReleaseDate!) {
                self.productDetailTitleLabel.text = "  Collection: \(dataModel.collectionName!)    Released: \(date.year())    Retail: $\(dataModel.retailPrice!)  "
            }else{
                self.productDetailTitleLabel.text = "  Collection: \(dataModel.collectionName!)    Released:     Retail: $\(dataModel.retailPrice!)  "
            }
        }
    }
    
    @IBAction func sellYoursNowButtonAction(_ sender: AnyObject) {
        
        loginCallBackAction(success: {
            
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
