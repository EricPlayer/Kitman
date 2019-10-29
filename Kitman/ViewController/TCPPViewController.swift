//
//  TCPPViewController.swift
//  Swagafied
//
//  Created by Amitabha on 23/07/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit

class TCPPViewController: BaseViewController {
    
    var pageType : TCPPType?
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.backgroundColor = UIColor.white
        
        // Add like button to navigation bar as right item
        let filterButton = UIButton()
        filterButton.setImage(UIImage(named: "Menu-Icon"), for: .normal)
        self.navigationBar.addRightBarButtons(rightButtons: [filterButton])
        
        // Add like button to navigation bar as left item

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.view.bringSubview(toFront: self.navigationBar)
        self.view.bringSubview(toFront: self.shadowImageView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let pageType = pageType{
            
            if pageType == .TermsAndCondition{
                // Load T & C HTML
                
                if let url = Bundle.main.url(forResource: Configuration.LocalHTMLS.TermsAndCondition, withExtension: "html"){
                    let request : NSMutableURLRequest = NSMutableURLRequest(url: url)
                    request.cachePolicy = .useProtocolCachePolicy
                    webView.loadRequest(request as URLRequest)
                }
                
            }else if pageType == .PrivacyPolicy{
                // Load PP HTML
                if let url = Bundle.main.url(forResource: Configuration.LocalHTMLS.PrivacyPolicy, withExtension:"html"){
                    let request : NSMutableURLRequest = NSMutableURLRequest(url: url)
                    request.cachePolicy = .useProtocolCachePolicy
                    webView.loadRequest(request as URLRequest)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Navigatin Bar Delegate -
    
    override func didSelectLeftButton(sender:UIButton) {
        
    }
    
    override func didSelectRightButton(sender:UIButton) {
        
        WindowManager.sharedManager.showMenu()
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
