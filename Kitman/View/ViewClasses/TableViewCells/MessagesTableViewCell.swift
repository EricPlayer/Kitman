//
//  MessagesTableViewCell.swift
//  Swagafied
//
//  Created by Amitabha on 23/07/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit

protocol MessagesTableViewCellDelegate {
    func didSelectReportButton(index: IndexPath)
    func didSelectLikeButton(index: IndexPath)
}

class MessagesTableViewCell: UITableViewCell {
    
    var liked : Bool = false
    var index: IndexPath!
    var delegate: MessagesTableViewCellDelegate!

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var reportMessageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK:- IBActions -
    
    
    @IBAction func tagButtonAction(_ sender: Any) {
        if let delegate = delegate{
            liked = true
            delegate.didSelectLikeButton(index:index)
        }
    }
    
    @IBAction func likeButtonAction(_ sender: AnyObject) {
        
    }
    
    @IBAction func reportMessageButtonAction(_ sender: AnyObject) {
        if let delegate = delegate{
            delegate.didSelectReportButton(index:index)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
