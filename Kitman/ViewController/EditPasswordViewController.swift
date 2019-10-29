//
//  EditPasswordViewController.swift
//  Swagafied
//
//  Created by Amitabha on 22/10/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class EditPasswordViewController: BaseViewController {

    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.enable = true
        self.shadowImageView.isHidden = false
        
        // Add like button to navigation bar as right item
        let filterButton = UIButton()
        filterButton.setImage(UIImage(named: "Menu-Icon"), for: .normal)
        
        self.navigationBar.addRightBarButtons(rightButtons: [filterButton])

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.view.bringSubview(toFront: self.shadowImageView)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveButtonAction(_ sender: AnyObject) {
        
        if confirmPasswordField.text! == newPasswordField.text!{
            
            if Utility.isValidPassword(testStr: confirmPasswordField.text!){
                
                let alert = UIAlertController(title: "Success", message: "Your password has been changed successfully", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }else{
                
                let alert = UIAlertController(title: "Error", message: "Please follow the password pattern (1 small char, 1 capital char, 1 special char, 8-15 chars total)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }else{
            
            let alert = UIAlertController(title: "Error", message: "Please enter same password for both the fields", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
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
