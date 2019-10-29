//
//  ProductListCell.swift
//  Swagafied
//
//  Created by Amitabha on 04/07/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProductListCell: UITableViewCell {
    
    var delegate : ProductCellDelegate?
    var indexPath : IndexPath?
    var productLiked : Bool = false
    var productShared : Bool = false
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productCatagoryLabel: UILabel!
    @IBOutlet weak var productTitleLabel: UILabel!
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var watchlistButton: UIButton!
    @IBOutlet weak var portfolioButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        infoButton.addTarget(self, action: #selector(ProductListCell.didSelectDetailsButton), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(ProductListCell.didSelectLikeButton), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(ProductListCell.didSelectShareButton), for: .touchUpInside)
        watchlistButton.addTarget(self, action: #selector(ProductListCell.didSelectWatchListButton), for: .touchUpInside)
        portfolioButton.addTarget(self, action: #selector(ProductListCell.didSelectPortfolioButton), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func startDownloadImage(){
        MBProgressHUD.showAdded(to: self, animated: true)
        productImageView.isHidden = true
    }
    
    func didFinishDownloadWithImage(downloadedImage : UIImage?,isDownloaded : Bool){
        
        var delay: Double = 0.0
        if isDownloaded{
            delay = 0.5
        }
        
        if let image = downloadedImage{
            MBProgressHUD.hide(for: self, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                // your code here
                self.productImageView.isHidden = false
                self.productImageView.image = image
            }
        }
    }
    
    /**
     Details Button Action
     */
    @objc func didSelectDetailsButton(){
        if let delegate = delegate{
            delegate.didSelectDetailsButton(indexPath: indexPath!)
        }
    }
    
    /**
     Select Button Action
     */
    @objc func didSelectLikeButton(){
        if let delegate = delegate{
            delegate.didSelectLikeButton(indexPath: indexPath!)
        }
    }
    
    /**
     Share Button Action
     */
    @objc func didSelectShareButton(){
        if let delegate = delegate{
            delegate.didSelectShareButton(indexPath: indexPath!)
        }
    }
    
    /**
     Share Button Action
     */
    @objc func didSelectPortfolioButton(){
        if let delegate = delegate{
            delegate.didSelectPortfolioButton(indexPath: indexPath!)
        }
    }
    /**
     Share Button Action
     */
    @objc func didSelectWatchListButton(){
        if let delegate = delegate{
            delegate.didSelectWatchlistButton(indexPath: indexPath!)
        }
    }
    
}
