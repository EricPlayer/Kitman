//
//  ProductObject.swift
//  Swagafied
//
//  Created by Amitabha on 04/08/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import UIKit
import ObjectMapper

class ProductResponse:Mappable{
    
    var isSuccessful : Bool = false
    var products : Array<ProductObject>?
    var message : String = String()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        isSuccessful <- map["success"]
        message <- map["msg"]
        if isSuccessful{
            products <- map["data.products"]
        }
    }
    
}

class Productdetail:Mappable{
    
    var isSuccessful : Bool = false
    var product : ProductObject?
    var message : String = String()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        isSuccessful <- map["success"]
        message <- map["msg"]
        if isSuccessful{
            product <- map["data"]
        }
    }
    
}

class ProductObject: Mappable {
    
    private var liked = false
    private var addedToPortfolio = false
    private var addedToWatchList = false
    var userRated = false
    var color : String?
    var totalRating : Int = 0
    var productRating : Float = 0
    var productName : String?
    var catagoryName : String?
    var collectionName : String?
    var euroSize : String?
    var id : String = String()
    var imageUrls : Array<String>?
    var productCatagory : String = String()
    var productCollection : String = String()
    var productTypeName : String?
    var productMainImage : UIImage?
    var localImageUrl : String?
    var productModelNumber : String?
    var productReleaseDate : String?
    var userRating : String?
    var retailPrice : String?
    var isShared : Bool = false
    var releasedYear : String?
    
    var isLiked : Bool {
        get{
            return liked
        }
    }
    
    func productLiked(isLiked : Bool){
        liked = isLiked
    }
    
    var isAddedToPortfolio : Bool {
        get{
            return addedToPortfolio
        }
        
        set{
            addToPortfolio(isAdded: newValue)
        }
    }
    
    func addToPortfolio(isAdded : Bool){
        addedToPortfolio = isAdded
    }
    
    var isAddedToWatchList : Bool {
        get{
            return addedToWatchList
        }
        
        set{
            addToWatchList(isAdded: newValue)
        }
    }
    
    func addToWatchList(isAdded : Bool){
        addedToWatchList = isAdded
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        productName <- map["product_name"]
        euroSize <- map["euro_size"]
        id <- map["id"]
        //imageUrls <- map["collection_name"]
        localImageUrl <- map["image_url"]
        euroSize <- map["euro_size"]
        productCatagory <- map["product_category"]
        productCollection <- map["product_collection"]
        catagoryName = productCatagory
        collectionName = productCollection
        productTypeName <- map["type_name"]
        productModelNumber <- map["model_no"]
        productReleaseDate <- map["added_date"]
        retailPrice <- map["retail"]
        productRating <- map["product_rating"]
        color <- map["color"]
        totalRating <- map["total_rating"]
        
        if let rating : String = map.JSON["product_rating"] as? String{
            productRating = Float(rating)!
        }
    }
    
    func convertToModelFromCoreData(item: Product){
        
        productName = item.productName ?? ""
        catagoryName = item.catagoryName ?? ""
        collectionName = item.collectionName ?? ""
//        euroSize <- item.euroSize ?? ""
        id = item.id ?? ""
        //imageUrls <- map["collection_name"]
        localImageUrl = item.imageURL ?? ""
        euroSize = item.euroSize ?? ""
        productCatagory = item.productCatagory ?? ""
        productCollection = item.productCollection ?? ""
        productTypeName = item.productTypeName ?? ""
        productModelNumber  = item.productModelNumber ?? ""
        productReleaseDate = item.productReleaseDate ?? ""
        retailPrice = item.retailPrice ?? ""
        productRating = item.productRating as! Float? ?? 2.0
        color = item.color ?? ""
        totalRating = item.totalRating as! Int? ?? 1
        
    }
}

class CollectionsList: Mappable {
    
    var isSuccessful : Bool = false
    var collections : Array<CollectionObject>?
    var message : String = String()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
     
        isSuccessful <- map["success"]
        message <- map["msg"]
        if isSuccessful{
            collections <- map["data.collections"]
        }
    }
}

class CollectionObject: Mappable {
    
    var addedDate: String?
    var collectionName: String?
    var id: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        addedDate <- map["added_date"]
        collectionName <- map["collection_name"]
        id <- map["id"]
        
    }
    
}

class CommentList: Mappable {
    
    var isSuccessful : Bool = false
    var comments : Array<Comment>?
    var message : String = String()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        isSuccessful <- map["success"]
        message <- map["msg"]
        
        if isSuccessful{
            comments <- map["data.product_comments"]
            
            guard let _ = comments else {
                comments <- map["data.product_reviews"]
                return
            }            
        }
    }
}

class Comment: Mappable {
    
    var name : String?
    var userName : String?
    var userID : String?
    var commentID : String?
    var time : String?
    var message : String?
    var email: String?
    var likes: Int?
    var liked: Bool = false
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        name <- map["name"]
        userName <- map["username"]
        userID <- map["user_id"]
        time <- map["added_date"]
        message <- map["comment"]
        commentID <- map["id"]
        likes <- map["total_like"]
        email <- map["email"]
        
        guard let _ = message else {
            message <- map["review"]
            return
        }
        
    }
}

class PortfolioResponse:Mappable{
    
    var isSuccessful : Bool = false
    var products : Array<Portfoliolist>?
    var message : String = String()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        isSuccessful <- map["success"]
        message <- map["msg"]
        if isSuccessful{
            products <- map["data.portfolio"]
        }
    }
}

class PortfolioWatchListBaseObject {
    
    var id : String?
    var userId : String?
    var productId : String?
    var size : String?
    var price : String?
    var addedDate : String?
    var imageUrl : String?
    var modelNo : String?
    var usSize : String?
    
}

class Portfoliolist: PortfolioWatchListBaseObject, Mappable {
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["portfolio_id"]
        userId <- map["user_id"]
        productId <- map["product_id"]
        size <- map["size"]
        price <- map["price"]
        addedDate <- map["added_date"]
        imageUrl <- map["image_url"]
        modelNo <- map["model_no"]
        usSize <- map["us_size"]
    }
}

class WatchlistResponse:Mappable{
    
    var isSuccessful : Bool = false
    var products : Array<WatchlistObject>?
    var message : String = String()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        isSuccessful <- map["success"]
        message <- map["msg"]
        if isSuccessful{
            products <- map["data.watchlist"]
        }
    }
}

class WatchlistObject: PortfolioWatchListBaseObject, Mappable {
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        userId <- map["user_id"]
        productId <- map["product_id"]
        size <- map["size"]
        price <- map["price"]
        addedDate <- map["added_date"]
        imageUrl <- map["image_url"]
        modelNo <- map["model_no"]
        usSize <- map["us_size"]
    }
}

class TimelineResponse:Mappable{
    
    var isSuccessful : Bool = false
    var products : Array<TimelineProduct>?
    var message : String = String()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        isSuccessful <- map["success"]
        message <- map["msg"]
        if isSuccessful{
            products <- map["data.timeline"]
        }
    }
}

class TimelineProduct: Mappable {
    
    var timelineId : String?
    var userId : String?
    var productId : String?
    var actionId : String?
    var message : String?
    var price : String?
    var productName : String?
    var imageUrl : String?
    var type : String?
    var name: String?
    var userName: String?
    var email: String?
    var likes: String?
    var lastReview: String?
    var userProfilePicUrl: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        timelineId <- map["id"]
        actionId <- map["type"]
        userId <- map["user_id"]
        productId <- map["product_id"]
        message <- map["message"]
        price <- map["price"]
        productName <- map["product_name"]
        imageUrl <- map["image_url"]
        type <- map["type"]
        name <- map["name"]
        userName <- map["username"]
        email <- map["email"]
        likes <- map["total_likes"]
        lastReview <- map ["last_comment"]
        userProfilePicUrl <- map["profile_pic_url"]
    }
}

class UserDetails: Mappable {
    
    var imageURL: String?
    var name: String?
    var userName: String?
    var email: String?
    var dateOfBirth: String?
    var company: String?
    var website: String?
    var phone: String?
    var city: String?
    var state: String?
    var zip: String?
    var country: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        name <- map["user_details.name"]
        userName <- map["user_details.username"]
        email <- map["user_details.email"]
        dateOfBirth <- map["user_details.date_of_birth"]
        company <- map["user_details.company"]
        website <- map["user_details.website"]
        phone <- map["user_details.phone"]
        city <- map["user_details.city"]
        state <- map["user_details.state"]
        zip <- map["user_details.zip"]
        country <- map["user_details.country"]
        imageURL <- map["user_details.profile_pic_url"]
    
    }
    
}

