//
//  ProductInfo.swift
//
//
//  Created by Amitabha on 10/09/16.
//
//

import Foundation
import CoreData


class ProductInfo: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    
    struct Static {
        static let ENTITY_NAME = "ProductInfo"
    }
    
    class func initWith(item : ItemModel , context: NSManagedObjectContext) -> ProductInfo?{
        
        let component = NSEntityDescription.insertNewObject(forEntityName: Static.ENTITY_NAME, into: context) as! ProductInfo
        
        component.productID = item.ItemId
        component.isLiked = NSNumber(value: item.ItemIsLiked)
        component.isShared = NSNumber(value: item.ItemIsShared)
        component.isMessaged = NSNumber(value: item.ItemIsMessaged)
        component.isRated = NSNumber(value: item.ItemIsRated)
        component.isAddedToPortfolio = NSNumber(value: item.ItemIsAddedToPortfolio)
        component.isAddedToWishList = NSNumber(value: item.ItemIsAddedToWatchList)
        
        return component
    }
    
}
