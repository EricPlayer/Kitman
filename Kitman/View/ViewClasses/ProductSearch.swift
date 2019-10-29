//
//  ProductSearch.swift
//  Swagafied
//
//  Created by Amitabha on 24/07/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit

class ProductSearch: UIView {
    
    var delegate : ProductSearchDelegate?
    var dataSource: Array<CollectionObject>?
    var selectedCollections : Array<String> = Array<String>()
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var makeItHappenButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        let nib = UINib(nibName: Configuration.XIBNames.ProductSearchXIB , bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        
    }
    
    func loadBrands(){
        
        if let dataSource = self.dataSource{
            
            var leftLastView : UIView?
            var rightLastView : UIView?
            
            for i in 0..<dataSource.count{
                
                if i%2 == 0{
                    
                    let object: CollectionObject = dataSource[i]
                    
                    let checkBox : UIButton = UIButton()
                    checkBox.tag = i
                    if selectedCollections.contains(object.collectionName!){
                        checkBox.setImage(UIImage(named: "Checkbox-Select-State"), for: .normal)
                    }else{
                        checkBox.setImage(UIImage(named: "white-checkbox"), for: .normal)
                    }
                    checkBox.addTarget(self, action: #selector( ProductSearch.toogleSelection(sender:) ), for: .touchUpInside)
                    self.scrollView.addSubview(checkBox)
                    
                    checkBox.autoPinEdge(.top, to: .top, of: leftLastView ?? self.scrollView, withOffset: 35)
                    checkBox.autoPinEdge(.leading, to: .leading, of: self.scrollView, withOffset: 10)
                    checkBox.autoSetDimension(.width, toSize: 20)
                    checkBox.autoSetDimension(.height, toSize: 20)
                    

                    let label : UILabel = UILabel()
                    label.text = object.collectionName
                    label.textColor = kWhiteColor
                    label.font = UIFont(name: kConstantinaFont, size: 15)
                    self.scrollView.addSubview(label)
                    
                    label.autoPinEdge(.top, to: .top, of: checkBox)
                    label.autoPinEdge(.leading, to: .trailing, of: checkBox, withOffset: 10)
                    label.autoSetDimension(.width, toSize: 110)
                    label.autoSetDimension(.height, toSize: 20)
                    
                    leftLastView = checkBox
                    
                }else{
                    
                    let object: CollectionObject = dataSource[i]
                    
                    let checkBox : UIButton = UIButton()
                    checkBox.tag = i
                    if selectedCollections.contains(object.collectionName!){
                        checkBox.setImage(UIImage(named: "Checkbox-Select-State"), for: .normal)
                    }else{
                        checkBox.setImage(UIImage(named: "white-checkbox"), for: .normal)
                    }
                    checkBox.addTarget(self, action: #selector(ProductSearch.toogleSelection(sender:)), for: .touchUpInside)
                    self.scrollView.addSubview(checkBox)
                    
                    checkBox.autoPinEdge(.top, to: .top, of: rightLastView ?? self.scrollView, withOffset: 35)
                    checkBox.autoPinEdge(.leading, to: .leading, of: self.scrollView, withOffset: 170)
                    checkBox.autoSetDimension(.width, toSize: 20)
                    checkBox.autoSetDimension(.height, toSize: 20)
                    
                
                    let label : UILabel = UILabel()
                    label.text = object.collectionName
                    label.textColor = kWhiteColor
                    label.font = UIFont(name: kConstantinaFont, size: 15)
                    self.scrollView.addSubview(label)
                    
                    label.autoPinEdge(.top, to: .top, of: checkBox)
                    label.autoPinEdge(.leading, to: .trailing, of: checkBox, withOffset: 10)
                    label.autoSetDimension(.width, toSize: 110)
                    label.autoSetDimension(.height, toSize: 20)
                    
                    rightLastView = checkBox

                }
                
            }
        }
    }
    
    @objc func toogleSelection(sender:UIButton){
        
        let image = sender.imageView?.image
        let name = dataSource![sender.tag].collectionName!
        
        if image == UIImage(named: "white-checkbox"){
            sender.setImage(UIImage(named: "Checkbox-Select-State"), for: .normal)
        
            selectedCollections.append( name )
            
        }else{
            sender.setImage(UIImage(named: "white-checkbox"), for: .normal)
            selectedCollections.removeObject(object: name)
        }
        
    }
    
    
    @IBAction func cancelButtonAction(_ sender: AnyObject) {
        if let delegate = self.delegate{
            delegate.didSelectCancelButton()
        }
    }
    
    @IBAction func resetButtonAction(_ sender: AnyObject) {
        
        selectedCollections.removeAll()        
        for view in self.scrollView.subviews {
            if let butn = view as? UIButton {
                butn.setImage(UIImage(named: "white-checkbox"), for: .normal)
            }
        }
    }
    
    @IBAction func makeItHappenButtonAction(_ sender: AnyObject) {
        
        if let delegate = self.delegate{
            delegate.didSelectMakeItHappenButton(selectedValues: selectedCollections)
        }
        
    }

}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

