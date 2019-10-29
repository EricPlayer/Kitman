//
//  Protocols.swift
//  Swagafied
//
//  Created by Amitabha on 21/07/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import Foundation

protocol NavigationBarDelegate {
    func didSelectRightButton(sender : UIButton)
    func didSelectLeftButton(sender : UIButton)
}

protocol ProductCellDelegate {
    func didSelectDetailsButton(indexPath:IndexPath)
    func didSelectLikeButton(indexPath:IndexPath)
    func didSelectShareButton(indexPath:IndexPath)
    func didSelectPortfolioButton(indexPath:IndexPath)
    func didSelectWatchlistButton(indexPath:IndexPath)
}

protocol ProductSearchDelegate {
    func didSelectResetButton()
    func didSelectCancelButton()
    func didSelectMakeItHappenButton(selectedValues:Array<String>)
}

protocol ProductRatingDelegate {
    func didSelectCancelButton()
    func didSelectRatingOptionWithRating(rating: Int)
}

