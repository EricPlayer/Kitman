//
//  Product+CoreDataProperties.swift
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

extension Product {

    @NSManaged var catagoryName: String?
    @NSManaged var collectionName: String?
    @NSManaged var color: String?
    @NSManaged var euroSize: String?
    @NSManaged var id: String?
    @NSManaged var productCatagory: String?
    @NSManaged var productCollection: String?
    @NSManaged var productModelNumber: String?
    @NSManaged var productName: String?
    @NSManaged var productRating: NSNumber?
    @NSManaged var productReleaseDate: String?
    @NSManaged var productTypeName: String?
    @NSManaged var retailPrice: String?
    @NSManaged var totalRating: NSNumber?
    @NSManaged var imageURL: String?
    

}
