//
//  TimelineTableViewCell.swift
//  Swagafied
//
//  Created by Amitabha on 30/10/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit

protocol TimelineTableViewCellDelegate {
    func likeButtonToogleActionn(indexPath: IndexPath, button: UIButton)
    func didSelectShareButtonn(indexPath: IndexPath, button: UIButton)
    func didSelectInfoButtonn(indexPath: IndexPath)
    func didSelectAllCommentsButtonn(indexPath: IndexPath)
}

class TimelineTableViewCell: UITableViewCell {
    
    var delegate: TimelineTableViewCellDelegate!
    var indexPath: IndexPath!
    var isLiked: Bool = false

    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var totalLikesLabel: UILabel!
    @IBOutlet weak var viewAllCommentsButton: UIButton!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - IBActions -
    @IBAction func likeButtonAction(sender: UIButton){
        if let delegate = delegate{
            delegate.likeButtonToogleActionn(indexPath: indexPath, button: sender)
        }
    }
    
    @IBAction func shareButtonAction(sender: UIButton){
        if let delegate = delegate{
            delegate.didSelectShareButtonn(indexPath: indexPath, button: sender)
        }
    }
    
    @IBAction func infoButtonAction(sender: UIButton){
        if let delegate = delegate{
            delegate.didSelectInfoButtonn(indexPath: indexPath)
        }
    }
    
    @IBAction func commentButtonAction(sender: UIButton){
        if let delegate = delegate{
            delegate.didSelectAllCommentsButtonn(indexPath: indexPath)
        }
    }
    
    @IBAction func messageAction(_ sender: Any) {
        if let delegate = delegate{
            delegate.didSelectAllCommentsButtonn(indexPath: indexPath)
        }
        
    }

}
