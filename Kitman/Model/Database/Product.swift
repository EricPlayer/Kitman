//
//  Product.swift
//  Swagafied
//
//  Created by Amitabha on 19/02/17.
//  Copyright © 2017 Amitabha Saha. All rights reserved.
//

import Foundation
import CoreData

@objc(Product)
class Product: NSManagedObject {

    // Insert code here to add functionality to your managed object subclass
    
    struct Static {
        static let ENTITY_NAME = "Product"
    }
    
    class func initWith(item : ProductObject , context: NSManagedObjectContext) -> Product?{
        
                let component = NSEntityDescription.insertNewObject(forEntityName: Static.ENTITY_NAME, into: context) as! Product
        
                component.retailPrice = item.retailPrice ?? ""
                component.totalRating = NSNumber(value: item.totalRating)
                component.productTypeName = item.productTypeName ?? ""
                component.productReleaseDate = item.productReleaseDate ?? ""
                component.productRating = NSNumber(value: item.productRating)
                component.productModelNumber = item.productModelNumber ?? ""
                component.productCollection = item.productCollection
                component.productCatagory = item.productCatagory
                component.id = item.id
                component.euroSize = item.euroSize ?? ""
                component.color = item.color ?? ""
                component.collectionName = item.collectionName ?? ""
                component.catagoryName = item.catagoryName ?? ""
                component.imageURL = item.localImageUrl ?? ""
                component.productName = item.productName ?? ""
                
                return component
    }
    
    
    
}
