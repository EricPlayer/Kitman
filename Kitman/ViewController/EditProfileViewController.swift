//
//  EditProfileViewController.swift
//  Swagafied
//
//  Created by Amitabha on 22/10/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import JSSAlertView
import CountryPicker
import Kingfisher
import MBProgressHUD

class EditProfileViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate , CountryPickerDelegate{
    
    var username: String = "QVVUSF9VU0VSX0lE"
    var userpassword: String = "QVVUSF9QQVNTV09SRA=="
    
    var imagePickerDisplayed = false
    var userImage: UIImage!
    var imageChanged = false
    var imageUploadAPI = UserImageUploadAPI()
    var userDataAPI = GetUserDataAPI()
    var userData = ["userName","email","firstName","lastName","dateOfBirth","company","website","phone","city","state","zip","country"]
    var user = User.sharedUser
    
    let imagePicker = UIImagePickerController()
    var updateUserProfile = UserProfileUpdateAPI()
    var imagePath: String?
    var pickerView: CountryPicker?
    var pickerToolBar: UIView?
    var pickerDummyView: UIView?
    
    @IBOutlet weak var addAvatarButton: UIButton!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        IQKeyboardManager.shared.enable = true

        // Do any additional setup after loading the view.
        
        self.shadowImageView.isHidden = false
        
        // Add like button to navigation bar as left item
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.darkGray , for: .normal)
        self.navigationBar.addLeftBarButton(leftButton: cancelButton,resize: false)
        
        // Add like button to navigation bar as right item
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.darkGray, for: .normal)
        self.navigationBar.addRightBarButtons(rightButtons: [doneButton],resize: false)
        
        country.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        if ( UserDefaults.standard.bool(forKey: Configuration.UserDefaultKeys.IsLoggedIn) == true )
        {
            getUserData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    func getUserData(){
        
        userDataAPI.didCompleteRequest = {
            (success) in
          self.loadData()
        }
        
        if imagePickerDisplayed == false{
            let _ = NetworkManager.sharedManager.request(apiObject: userDataAPI)
        }else{
            imagePickerDisplayed = true
        }
        
    }
    
    func loadData(){
        
        let name = userDataAPI.userData?.name
        
        if let nameUnwraped = name{
            if nameUnwraped.contains("_"){
                
                let array = nameUnwraped.components(separatedBy: "_")
                self.firstName.text = array[0]
                self.lastName.text = array[1]
                
            }
        }
        
        self.userName.text = userDataAPI.userData?.userName
        self.email.text = userDataAPI.userData?.email
        self.dateOfBirth.text = convertDate(dateString: (userDataAPI.userData?.dateOfBirth)!)
        self.company.text = userDataAPI.userData?.company
        self.website.text = userDataAPI.userData?.website
        self.phone.text = userDataAPI.userData?.phone
        self.city.text = userDataAPI.userData?.city
        self.state.text = userDataAPI.userData?.state
        self.zip.text = userDataAPI.userData?.zip
        self.country.text = userDataAPI.userData?.country
        
        activityIndicator.isHidden = true
        if let imageUrl = userDataAPI.userData?.imageURL{
            let urlString = imageUrl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            if let url = URL(string: urlString!){
            
                addAvatarButton.kf.setImage(with: ImageResource(downloadURL: url) , for: .normal)
                addAvatarButton.kf.setImage(with: ImageResource(downloadURL: url), for: .normal, placeholder: UIImage(named: "addAvatar"), options: nil, progressBlock: { (written, total) in
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                    print("\(written) : \(total)")
                }, completionHandler: { (image, error, cacheType, url) in
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    print("done")
                })
                
                addAvatarButton.imageView?.contentMode = .scaleAspectFill
                addAvatarButton.layer.cornerRadius = 50.0
                addAvatarButton.clipsToBounds = true
                
            }
        }
    }
    
    @IBAction func addAvatarAction(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Image Gallery", style: .default , handler:{ (UIAlertAction)in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
            
            
        }))
        self.present(alert, animated: true, completion: {
            
        })
        
    }
    
    //MARK:- ImagePicker controller delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageChanged = true
            userImage = pickedImage
            
            addAvatarButton.setImage(pickedImage, for: .normal)
            addAvatarButton.imageView?.contentMode = .scaleAspectFill
            
            addAvatarButton.layer.cornerRadius = 50.0
            addAvatarButton.clipsToBounds = true
        }
        imagePickerDisplayed = true
        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerDisplayed = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.view.endEditing(true)
        
        pickerDummyView = UIView(frame: UIScreen.main.bounds )
        self.view.addSubview(pickerDummyView!)
        
        pickerView = CountryPicker(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 300, width: UIScreen.main.bounds.width, height: 300))
        pickerView?.backgroundColor = UIColor.lightGray
        pickerView?.delegate = self
        self.view.addSubview(pickerView!)
        
        pickerToolBar = UIView(frame: CGRect(x: 0, y: (pickerView?.frame.origin.y)!, width: UIScreen.main.bounds.width, height: 50))
        pickerToolBar?.backgroundColor = UIColor.lightGray
        self.view.addSubview(pickerToolBar!)
        
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        pickerToolBar!.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        
        cancelButton.frame = CGRect(x: 10, y: 0, width: 60, height: 50)
        
        
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        pickerToolBar!.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        
        doneButton.frame = CGRect(x: view.frame.width-70, y:0, width: 60, height: 50)

    }
    
    @objc func cancelButtonAction(){
        //self.country.text = ""
        pickerDummyView?.removeFromSuperview()
        pickerToolBar?.removeFromSuperview()
        pickerView?.removeFromSuperview()
        self.country.text = ""
    }
    
    @objc func doneButtonAction(){
        pickerDummyView?.removeFromSuperview()
        pickerToolBar?.removeFromSuperview()
        pickerView?.removeFromSuperview()
    }
    
    func countryPicker(_ picker: CountryPicker!, didSelectCountryWithName name: String!, code: String!) {
        self.country.text = name
    }
    
    //MARK:- Navigatin Bar Delegate -
    
    override func didSelectLeftButton(sender:UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
    
    override func didSelectRightButton(sender:UIButton) {
        
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        updateUserProfile.paramList1 = ["user_id": Utility.getUserID() ,
                                       "name": "\(firstName.text ?? "")_\(lastName.text ?? "")",
                                       "user_type": "1",]
        updateUserProfile.paramList2 = ["date_of_birth":"\(dateOfBirth.text ?? "")","company":"\(company.text ?? "")","website":"\(website.text ?? "")"]
        updateUserProfile.paramList3 = ["phone":"\(phone.text ?? "")" ,"city" : "\(city.text ?? "")","state" : "\(state.text ?? "")"]
        updateUserProfile.paramList4 = ["zip" : "\(zip.text ?? "")","country" : "\(country.text ?? "")" ,"username": "\(userName.text ?? "")","auth_user_id": username , "auth_password": userpassword]
        
        updateUserProfile.didCompleteRequest = { [weak self] success in
            
            if success{
                
                if self?.imageChanged == true{
                    
                    //self?.userImage
                    self?.imageUploadAPI.image = self?.resizeImage(image: (self?.userImage)!,newWidth: 200) ?? UIImage(named: "addAvatar")
                    self?.imageUploadAPI.uploadImage()
                    self?.imageUploadAPI.didCompleteRequest = { [weak self] success in
                        
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: self!.view, animated: true)
                        }
                        
                        if success == true{
                            
                            let alert = UIAlertController(title: "Success", message: "Your user profile has been updated.", preferredStyle: UIAlertControllerStyle.alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { handler in
                                
                                self!.dismiss(animated: true) {}
                                
                            }))
                            
                            DispatchQueue.main.async{
                                self!.present(alert, animated: true, completion: nil)
                            }
                            
                        }
                        else{
                            
                            let alert = UIAlertController(title: "Error", message: "Your user profile image upload Error.", preferredStyle: UIAlertControllerStyle.alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { handler in
                                
                            }))
                            
                            DispatchQueue.main.async{
                                self!.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                    
                }
                
                else{
                    
                    let alert = UIAlertController(title: "Success", message: "Your profile data has been updated successfully.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { handler in
                        
                    }))
                    self!.present(alert, animated: true, completion: nil)
                    
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self!.view, animated: true)
                    }
                }
            }
            else{
                
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self!.view, animated: true)
                }
                
                let alert = UIAlertController(title: "Error", message: "Your user profile data upload Error.", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { handler in
                    
                }))
                self!.present(alert, animated: true, completion: nil)
            }
        }
        
        let _ = NetworkManager.sharedManager.request(apiObject:self.updateUserProfile)
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        if image == nil {
            
            //print("missing image at: \(path)")
        }
        //print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }
    
    private func convertDate(dateString: String) -> String?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateObj = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let date = dateObj{
            return dateFormatter.string(from: date)
        }else{
            return nil
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0,y: 0,width: newWidth,height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
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
