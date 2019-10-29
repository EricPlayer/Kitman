//
//  NavigationBar.swift
//  Tap House 23
//
//  Created by Amitabha on 04/07/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit
import PureLayout

class NavigationBar: UIView {
    
    var leftBarButton : UIButton?
    var rightBarButton : UIButton?
    
    var menuButton : UIButton?
    var appNameLabel : UILabel?
    var backImage : UIButton?
    var delegate : NavigationBarDelegate?
    
    var pageHeader : String?{
        didSet{
            appNameLabel?.text = pageHeader
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func awakeFromNib(){
        super.awakeFromNib()
        setupUI()
        
    }
    
    func setupUI(){
        
        self.backgroundColor = Configuration.NavigationBar.NavigationBarBackgroundColor

        // App Icon
        appNameLabel = UILabel()
        appNameLabel?.text = "Kitman"
        appNameLabel?.font = Configuration.NavigationBar.NavigationBarFont
        appNameLabel?.textAlignment = .center
        self.addSubview(appNameLabel!)
        
        appNameLabel?.autoPinEdge(.top, to: .top, of: self, withOffset: Configuration.NavigationBar.NavigationBarButtonTopPadding)
        appNameLabel?.autoAlignAxis(toSuperviewAxis: .vertical)
        appNameLabel?.autoSetDimension(.width, toSize: Configuration.NavigationBar.NavigationBarTextWidth)
        appNameLabel?.autoSetDimension(.height, toSize: Configuration.NavigationBar.NavigatiobBarButtonSize-5)
        
        self.alpha = 0.8
    }
    
    /**
     Add right navigation bar button
     
     - parameter rightButton: UIButton object
     */
    func addRightBarButtons(rightButtons:[UIButton],resize:Bool = true) -> Void {
        
        if(rightBarButton != nil){
            rightBarButton?.removeFromSuperview()
        }
        
        var previousButton: UIButton?
        
        for i in (0..<rightButtons.count).reversed() {
            let ritbutton = rightButtons[i]
            ritbutton.tag = i
            ritbutton.addTarget(self, action: #selector(NavigationBar.rightBarButtonAction(sender:) ), for: .touchUpInside)
            self.addSubview(ritbutton)
            
            ritbutton.autoPinEdge(.top, to: .top, of: self, withOffset: Configuration.NavigationBar.NavigationBarButtonTopPadding)
            
            if let previousButton = previousButton{
                ritbutton.autoPinEdge(.trailing, to: .leading , of: previousButton, withOffset: 5.0)
            }else{
                ritbutton.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -Configuration.NavigationBar.NavigationBarButtonSidePadding)
            }
            
            previousButton = ritbutton
            if (resize == true){
                ritbutton.autoSetDimension(.width, toSize: Configuration.NavigationBar.NavigatiobBarButtonSize)
            }
            ritbutton.autoSetDimension(.height, toSize: Configuration.NavigationBar.NavigatiobBarButtonSize)
        }
    }
    
    /**
     Add left navigation bar button
     
     - parameter leftButton: UIButton object
     */
    func addLeftBarButton(leftButton:UIButton,resize:Bool = true) -> Void {
        
        if(leftBarButton != nil){
            leftBarButton?.removeFromSuperview()
        }
        
        leftBarButton = leftButton
        leftButton.addTarget(self, action: #selector(NavigationBar.leftBarButtonAction(sender:) ), for: .touchUpInside)
        self.addSubview(leftButton)
        
        leftButton.autoPinEdge(.top, to: .top, of: self, withOffset: Configuration.NavigationBar.NavigationBarButtonTopPadding)
        leftButton.autoPinEdge(.leading, to: .leading, of: self, withOffset: Configuration.NavigationBar.NavigationBarButtonSidePadding)
        if (resize == true){
            leftButton.autoSetDimension(.width, toSize: Configuration.NavigationBar.NavigatiobBarButtonSize-5)
        }
        leftButton.autoSetDimension(.height, toSize: Configuration.NavigationBar.NavigatiobBarButtonSize-5)
        
    }
    
    
    func addLeftBarButtons(leftButtons:[UIButton],resize:Bool = true) -> Void {
        
        if(leftBarButton != nil){
            leftBarButton?.removeFromSuperview()
        }
        
        var previousButton: UIButton?
        
        for i in (0..<leftButtons.count){
            let ritbutton = leftButtons[i]
            ritbutton.tag = i
            ritbutton.addTarget(self, action: #selector(NavigationBar.leftBarButtonAction(sender:) ), for: .touchUpInside)
            self.addSubview(ritbutton)
            
            ritbutton.autoPinEdge(.top, to: .top, of: self, withOffset: Configuration.NavigationBar.NavigationBarButtonTopPadding)
            
            if let previousButton = previousButton{
                ritbutton.autoPinEdge(.leading, to: .trailing , of: previousButton, withOffset: 5.0)
            }else{
                ritbutton.autoPinEdge(.leading, to: .leading, of: self, withOffset: Configuration.NavigationBar.NavigationBarButtonSidePadding)
            }
            
            previousButton = ritbutton
            if (resize == true){
                ritbutton.autoSetDimension(.width, toSize: Configuration.NavigationBar.NavigatiobBarButtonSize)
            }
            ritbutton.autoSetDimension(.height, toSize: Configuration.NavigationBar.NavigatiobBarButtonSize)
        }
        
    }
    
    /**
     Right navigation button delegate method
     
     - parameter sender: UIButton object
     */
    @objc func rightBarButtonAction(sender : UIButton) {
        if let delegate = self.delegate{
            delegate.didSelectRightButton(sender: sender)
        }
    }
    
    /**
     Left navigation button delegate method
     
     - parameter sender: UIButton object
     */
    @objc func leftBarButtonAction(sender : UIButton) {
        if let delegate = self.delegate{
            delegate.didSelectLeftButton(sender: sender)
        }
    }
    
    func didSelectShareOption(sender : UIButton) {
        
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}
