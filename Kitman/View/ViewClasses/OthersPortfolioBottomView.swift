//
//  OthersPortfolioBottomView.swift
//  Swagafied
//
//  Created by Amitabha on 20/11/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit

class OthersPortfolioBottomView: UIView {

    @IBOutlet weak var userAvartar: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var followUserButton: UIButton!
    @IBOutlet weak var portfolioAddButton: UIButton!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
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
        let nib = UINib(nibName: Configuration.XIBNames.OthersPortfolio , bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        
    }


}
