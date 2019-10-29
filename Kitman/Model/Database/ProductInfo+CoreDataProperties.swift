//
//  ProductInfo+CoreDataProperties.swift
//  Swagafied
//
//  Created by Amitabha on 19/02/17.
//  Copyright © 2017 Amitabha Saha. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ProductInfo {

    @NSManaged var isAddedToPortfolio: NSNumber?
    @NSManaged var isAddedToWishList: NSNumber?
    @NSManaged var isLiked: NSNumber?
    @NSManaged var isMessaged: NSNumber?
    @NSManaged var isRated: NSNumber?
    @NSManaged var isShared: NSNumber?
    @NSManaged var productID: String?

}
