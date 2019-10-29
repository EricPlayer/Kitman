//
//  Extensions.swift
//  Swagafied
//
//  Created by Amitabha on 23/07/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import Foundation
import UIKit

// UIViewController+Storyboard
extension UIViewController{
    func loadViewControllerFromStroryboard(storyboard:String, viewControllerIndentifier: String) -> UIViewController{
        let storyBoard : UIStoryboard = UIStoryboard(name: storyboard, bundle: nil)
        let viewController : UIViewController = storyBoard.instantiateViewController(withIdentifier: viewControllerIndentifier)
        
        return viewController
    }
}

extension UIColor{
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
