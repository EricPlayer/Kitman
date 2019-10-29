//
//  PlainTableViewCell.swift
//  Swagafied
//
//  Created by Amitabha on 06/11/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit

class PlainTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
