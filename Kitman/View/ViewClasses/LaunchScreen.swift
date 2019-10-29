//
//  LaunchScreen.swift
//  Swagafied
//
//  Created by Amitabha on 20/03/17.
//  Copyright © 2017 Amitabha Saha. All rights reserved.
//

import Foundation
import UIKit

class LaunchScreen: UIView{
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var descriptionSubTitle: UILabel!
    
    
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
        let nib = UINib(nibName: Configuration.XIBNames.LaunchScreenXIB , bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
    
}
