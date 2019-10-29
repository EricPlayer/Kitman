//
//  Configuration.swift
//  Swagafied
//
//  Created by Amitabha on 04/07/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit
import Foundation

struct Configuration {

}

extension Configuration{
    struct NavigationBar {
        static let NavigationBarHeight:CGFloat = 70.0
        static let NavigationBarBackgroundColor = UIColor.white
        static let NavigationBarFont : UIFont = UIFont.init(name: "Pristina-Regular", size: 26)!
        static let NavigationBarNormalFont : UIFont = UIFont.systemFont(ofSize: 20)
        static let NavigationBarTextWidth : CGFloat = 200
        static let NavigationBarTextHeight : CGFloat = 40
        static let NavigatiobBarButtonSize : CGFloat = 33.0
        static let NavigationBarButtonSidePadding : CGFloat = 20.0
        static let NavigationBarButtonTopPadding : CGFloat = 30.0
    }
}

extension Configuration {
    // configure default heights, widths, sizes, and frames here
    struct Sizes {
        static let ScreenWidth:CGFloat = (UIScreen.main.bounds.size.width)
        static let ScreenHeight:CGFloat = (UIScreen.main.bounds.size.height)
        static let ScreenSize:CGSize = UIScreen.main.bounds.size
        static let ProductTableCellHeight:CGFloat = 420.0
        static let TimelineTableCellHeight:CGFloat = 480.0
        static let MessagesTableCellHeight:CGFloat = 100.0
    }
}

extension Configuration {
    // configure default heights, widths, sizes, and frames here
    struct CellIdentifier {
        static let ProductListTableViewCell:String = "ProductListTableViewCellIdentifier"
        static let MessagesTableViewCell : String = "messagesTableViewCell"
        static let MenuCell : String = "menuCell"
        static let TimelineTableViewCell : String = "TimelineTableViewCell"
        //menuCell
    }
}

extension Configuration {
    // configure default heights, widths, sizes, and frames here
    struct ViewControllers {
        static let ProductListViewController:String = "ProductListViewController"
        static let ProductDetailViewController:String = "ProductDetailViewController"
        static let LoginSignupViewController:String = "LoginSignupViewController"
        static let TCPPViewController:String = "TCPPViewController"
        static let MessagesViewController:String = "MessagesViewController"
        static let SellerViewController:String = "SellerViewController"
        static let SellYoursNowViewController:String = "SellYoursNowViewController"
        static let EditProfileViewController:String = "EditProfileViewController"
        static let PortfolioListViewController:String = "PortfolioListViewController"
        static let WatchListViewController:String = "WatchListViewController"
        static let PortfolioProductDetailViewController: String = "PortfolioProductDetailViewController"
        static let TimeLineViewController:String = "TimeLineViewController"
        static let EditPasswordViewController:String = "EditPasswordViewController"
    }
}

extension Configuration {
    // configure default heights, widths, sizes, and frames here
    struct Storyboard {
        static let MainStoryBoard:String = "Main"
    }
}

extension Configuration {
    // configure default heights, widths, sizes, and frames here
    struct StoryboardVC {
        static let ProductListViewController:String = "ProductListViewController"
        static let ProductDetailViewController:String = "ProductDetailViewController"
        static let LoginSignupViewController:String = "LoginSignupViewController"
        static let TCPPViewController:String = "TCPPViewController"
        static let MessagesViewController:String = "MessagesViewController"
        static let SellerViewController:String = "SellerViewController"
        static let SellYoursNowViewController:String = "SellYoursNowViewController"
        static let RightMenuViewController:String = "RightMenuViewController"
        static let EditProfileViewController:String = "EditProfileViewController"
        static let PortfolioListViewController:String = "PortfolioListViewController"
        static let TimeLineViewController:String = "TimeLineViewController"
    }
}

extension Configuration {
    // configure default heights, widths, sizes, and frames here
    struct SegueNames {
        static let ShowProductDetailViewController:String = "showProductDetailPage"
        static let ShowPoftfolioProductDetailViewController:String = "showPortfolioDetails"
        static let ShowProductDetailViewControllerFromPortfolio:String = "portfolioDetail"
        static let ShowPortfolioViewControllerFromTimeline:String = "timelineDetailSegue"
        static let ShowProductDetailViewControllerFromTimeline:String = "productDetailFromTimeLine"
        
    }
}

extension Configuration {
    // configure default heights, widths, sizes, and frames here
    struct XIBNames {
        static let ProductListTableViewCellXIB:String = "ProductListCell"
        static let ProductSearchXIB:String = "ProductSearch"
        static let LaunchScreenXIB:String = "LaunchScreen"
        static let TimelineTableViewCell:String = "TimelineTableViewCell"
        static let ShoeSizePicker: String = "ShoeSizePicker"
        static let OthersPortfolio: String = "OthersPortfolio"
        static let ProductCommentsView: String = "ProductCommentsView"
    }
}

extension Configuration {
    // configure default heights, widths, sizes, and frames here
    struct UserDefaultKeys {
        static let IsLaunched:String = "IsLaunched"
        static let IsLoggedIn:String = "IsLoggedIn"
        static let IsNotified:String = "IsNotified"
        static let UserID:String = "Swagafied.User.UserModel.userID"
    }
}

extension Configuration {
    // configure default heights, widths, sizes, and frames here
    struct DeviceInfo {
        static let DeviceID:String = "DeviceID"
    }
}

extension Configuration {
    // configure default heights, widths, sizes, and frames here
    struct ImagedownloadSettings {
        static let imageCountInSet : Int = 30
    }
}

extension Configuration {
    // configure default heights, widths, sizes, and frames here
    struct LocalHTMLS {
        static let PrivacyPolicy:String = "Privacy_Policy"
        static let TermsAndCondition:String = "Terms_and_Conditions"
    }
}


extension Configuration {
    // configure default heights, widths, sizes, and frames here
    struct API {
        static let baseAPIUrlStating:String = "http://webolation.com/sneakers/web_service/"
        static let baseAPIURLproduction:String = ""
        static let shouldUseProductionURL : Bool = false
        
        static let oneSignalAppID:String = "97d694a4-f837-48f0-8944-3863e58ba657"
        static let googleAdAppID:String = "ca-app-pub-6626593325937491~5820529567"
        static let adUnitID:String = "ca-app-pub-6626593325937491/1111128369"
        
        struct Path {
            static let ProductList : String = "product_list"
            static let ProductImageReport : String = "report_image"
            static let ProductLike : String = "like_product"
            static let ProductUnLike: String = "unlike_product"
            static let AllCollections: String = "all_collections"
            static let AllMessages: String = "comment_list"
            static let Registration: String = "user_registration"
            static let Login: String = "user_login"
            static let PostComment: String = "post_comment"
            static let PostRating: String = "post_rating"
            static let AddToPortfolio: String = "add_portfolio"
            static let RemoveFromPortfolio: String = "remove_portfolio"
            static let Portfolio: String = "portfolio"
            static let AddToWatchlist: String = "add_watchlist"
            static let RemoveFromWatchList: String = "remove_watchlist"
            static let Watchlist: String = "watchlist"
            static let ProductDetails: String = "product_details"
            static let EditPortfolio: String = "edit_portfolio"
            static let EditWatchlist: String = "edit_watchlist"
            static let UpdateUser: String = "update_user"
            static let UpdateUserNew: String = "update_user_new"
            static let UserTimeline: String = "timeline"
            static let ReportComment: String = "report_comment"
            static let LikeComment: String = "like_comment"
            static let PostReview: String = "post_review"
            static let ReviewList: String = "review_list"
            static let LikeReview: String = "like_review"
            static let DislikeReview: String = "unlike_review"
            static let ReportReview: String = "report_review"
            static let MasterData: String = "get_master_data"
            static let UpdateProfilePic: String = "update_profile_picture"
            static let UpdateProfilePicNew: String = "update_profile_picture_new"
        }
    }
}

extension Configuration{
    struct NetworkError {
        static let InternetNotReachable : Int = -1001
        static let InternetOffline : Int = -1009
        static let InternetConnectionLost : Int = -1005
    }
}

extension Configuration{
    struct Notification {
        static let UserInfoKey : String = "statusCode"
        static let NoInternetNotification : String = "Configuration.notification.noInternetNotification"
        static let DidAppearMenu : String = "DidAppearMenu"
        static let WillAppearMenu : String = "WillAppearMenu"
        static let WillHideMenu : String = "WillHideMenu"
        static let DidHideMenu : String = "DidHideMenu"
        static let LogInSuccessful : String = "LogInSuccessful"
        static let LogOutSuccessful : String = "LogOutSuccessful"
        }
}


