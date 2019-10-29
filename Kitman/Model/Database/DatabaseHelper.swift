//
//  ProductSearch.swift
//  Swagafied
//
//  Created by Amitabha on 24/07/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import Foundation
import CoreData

extension ProductObject{
    
//    var totalRating: Float?
//    var retailPrice: String?
//    var productTypeName: String?
//    var productReleaseDate: String?
//    var productRating: Float?
//    var productModelNumber: String?
//    var productCollection: String?
//    var productCatagory: String?
//    var id: String?
//    var euroSize: String?
//    var color: String?
//    var collectionName: String?
//    var catagoryName: String?
//    
//    init(){
//        
//    }
    
    func mapData(product : Product){
        
        self.totalRating = (product.totalRating?.intValue)! //(product.totalRating! as Int?)!
        self.retailPrice = product.retailPrice!
        self.productTypeName = product.productTypeName
        self.productReleaseDate = product.productReleaseDate
        self.productRating = (product.productRating as! Float?)!
        self.productModelNumber = product.productModelNumber
        self.productCollection = product.productCollection!
        self.productCatagory = product.productCatagory!
        self.id = product.id!
        self.euroSize = product.euroSize
        self.color = product.color
        self.collectionName = product.collectionName
        self.catagoryName = product.catagoryName
    }
    
}

class ItemModel{
    
    var ItemId : String = ""
    var ItemIsLiked : Bool = false
    var ItemIsShared : Bool = false
    var ItemIsMessaged : Bool = false
    var ItemIsRated : Bool = false
    var ItemIsAddedToPortfolio : Bool = false
    var ItemIsAddedToWatchList : Bool = false
    
    init(){
        
    }
    
    init(product : ProductInfo){
        
        self.ItemId = product.productID!
        self.ItemIsLiked = (product.isLiked?.boolValue) ?? false
        self.ItemIsShared = (product.isShared?.boolValue) ?? false
        self.ItemIsMessaged = (product.isMessaged?.boolValue) ?? false
        self.ItemIsRated = (product.isRated?.boolValue) ?? false
        self.ItemIsAddedToPortfolio = (product.isAddedToPortfolio?.boolValue) ?? false
        self.ItemIsAddedToWatchList = (product.isAddedToWishList?.boolValue) ?? false
    }
    
}

class CoreDataAdapter{
    
    // MARK: - Core Data stack -
    lazy var applicationDocumentsDirectory: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "Kitman", withExtension: "momd")
        return NSManagedObjectModel(contentsOf: modelURL!)!
    }()
    

    var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        
        get {
            if _persistentStoreCoordinator != nil {
                return _persistentStoreCoordinator
            }
            
            _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            let url = self.applicationDocumentsDirectory.appendingPathComponent("Swagafied.sqlite")
            
            do {
                let _ = try _persistentStoreCoordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            } catch  {
                
                // abort()
            }
            
            return _persistentStoreCoordinator
        }
        
    }
    
    var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    
    
    var managedObjectContext: NSManagedObjectContext? {
        
        get {
            
            if _managedObjectContext != nil {
                return _managedObjectContext
            }
            
            let coordinator = persistentStoreCoordinator
            if coordinator == nil {
                return nil
            }
            _managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
            
            _managedObjectContext?.persistentStoreCoordinator = coordinator
            
            return _managedObjectContext
        }
    }
    
    var _managedObjectContext: NSManagedObjectContext?
    
}

class DatabaseHelper: NSObject {
    
    var coreData: CoreDataAdapter!
    
    // MARK:- Init Methods -
    static let sharedHelper = DatabaseHelper()
    
    required override init() {
        coreData = CoreDataAdapter()
    }
    
    
    // MARK:- Public Methods For Product Meta Data-
    func insertItem(item : ItemModel){
        
        let context = coreData.managedObjectContext
        deleteComponent(id: item.ItemId)
        
        if let _ = ProductInfo.initWith(item: item, context: context!){
            saveContext()
        }
    }
    
    func fetchItemForID(id : String) -> ProductInfo?{
        
        if ( UserDefaults.standard.bool(forKey: Configuration.UserDefaultKeys.IsLoggedIn) == false )
        {
            return nil
        }
        
        var components : [ProductInfo]
        var error: NSError? = nil
        var fetchResults: [AnyObject]?
        
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: ProductInfo.Static.ENTITY_NAME)
        fetchRequest.predicate = NSPredicate(format: "productID == %@", id)
        
        if let moc = coreData.managedObjectContext {
            do {
                fetchResults = try moc.fetch(fetchRequest)
            } catch let error1 as NSError {
                error = error1
                fetchResults = nil
            }
            if error != nil {
                print ("Unable to fetch data")
                
            } else {
                components = (fetchResults as? [ProductInfo])!
                return components.count > 0 ?  components[0] : nil
            }
        }else{
            print ("Different Context Object")
            return nil
        }
        
        return nil
        
    }
    
    func fetchProductListWithPredicate(filter : NSPredicate) -> [ProductInfo]?{
        
        var components : [ProductInfo]
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: ProductInfo.Static.ENTITY_NAME)
        fetchRequest.predicate = filter
        
        var error: NSError? = nil
        var fetchResults: [AnyObject]?
        
        if let moc = coreData.managedObjectContext {
            do {
                fetchResults = try moc.fetch(fetchRequest)
            } catch let error1 as NSError {
                error = error1
                fetchResults = nil
            }
            if error != nil {
                print ("Unable to fetch data")
                
            } else {
                components = (fetchResults as? [ProductInfo])!
                return components
            }
        }else{
            print ("Different Context Object")
            return nil
        }
        
        return nil
    }
    
    func fetchAllProductList() -> [ProductInfo]?{
        
        var components : [ProductInfo]
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: ProductInfo.Static.ENTITY_NAME)
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        var error: NSError? = nil
        var fetchResults: [AnyObject]?
        
        if let moc = coreData.managedObjectContext {
            do {
                fetchResults = try moc.fetch(fetchRequest)
            } catch let error1 as NSError {
                error = error1
                fetchResults = nil
            }
            if error != nil {
                print ("Unable to fetch data")
                
            } else {
                components = (fetchResults as? [ProductInfo])!
                return components
            }
        }else{
            print ("Different Context Object")
            return nil
        }
        
        return nil
    }
    
    func updateItem(item : ItemModel){
        
        if let savedItem : ProductInfo = fetchItemForID(id: item.ItemId){
            
            savedItem.isMessaged = item.ItemIsMessaged as NSNumber?
            savedItem.isLiked = item.ItemIsLiked as NSNumber?
            savedItem.isShared = item.ItemIsShared as NSNumber?
            savedItem.isRated = item.ItemIsRated as NSNumber?
            savedItem.isAddedToWishList = item.ItemIsAddedToWatchList as NSNumber?
            savedItem.isAddedToPortfolio = item.ItemIsAddedToPortfolio as NSNumber?
            
            saveContext()
        }
    }
    
    func deleteAll(){
        
    }
    
    /*
     - (void)deleteAllEntities:(NSString *)nameEntity
     {
     NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:nameEntity];
     [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
     
     NSManagedObjectContext *context = [self managedObjectContext];
     NSError *error;
     NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
     for (NSManagedObject *object in fetchedObjects)
     {
     [context deleteObject:object];
     }
     
     error = nil;
     [context save:&error];
     }
    */
    
    // MARK:- Private Methods -
    private func deleteComponent(id : String){
        
        if let item : ProductInfo = fetchItemForID(id: id){
            coreData.managedObjectContext?.delete(item)
            print("Previuous Object Deleted : %@",item.productID)
            saveContext()

        }
    }
    
    func saveContext () {
        if let moc = coreData.managedObjectContext {
            if moc.hasChanges {
                do {
                    try moc.save()
                    print("saved")
                    
                } catch let error as NSError{
                    moc.rollback() // rollback and continue here??
                    print("not saved : Reason == > %@",error.description)
                }
            }
        }
    }
}

extension DatabaseHelper{
    
    func insertProduct(item : ProductObject){
        
        let context = coreData.managedObjectContext
        deleteProduct(id: item.id)
        
        if let _ = Product.initWith(item: item, context: context!){
            saveContext()
        }
        
    }
    
    func fetchProductForID(id : String) -> Product?{
        
        var components : [Product]
        var error: NSError? = nil
        var fetchResults: [AnyObject]?
        
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Product.Static.ENTITY_NAME)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        if let moc = coreData.managedObjectContext {
            do {
                fetchResults = try moc.fetch(fetchRequest)
            } catch let error1 as NSError {
                error = error1
                fetchResults = nil
            }
            if error != nil {
                print ("Unable to fetch data")
                
            } else {
                components = (fetchResults as? [Product])!
                return components.count > 0 ?  components[0] : nil
            }
        }else{
            print ("Different Context Object")
            return nil
        }
        
        return nil
    }
    
    func fetchProductList() -> [Product]?{
        
        var components : [Product]
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Product.Static.ENTITY_NAME)
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        var error: NSError? = nil
        var fetchResults: [AnyObject]?
        
        if let moc = coreData.managedObjectContext {
            do {
                fetchResults = try moc.fetch(fetchRequest)
            } catch let error1 as NSError {
                error = error1
                fetchResults = nil
            }
            if error != nil {
                print ("Unable to fetch data")
                
            } else {
                components = (fetchResults as? [Product])!
                return components
            }
        }else{
            print ("Different Context Object")
            return nil
        }
        
        return nil
    }
    
    func updateProduct(product : Product){
        
        if let savedItem : Product = fetchProductForID(id: product.id!){
            
            savedItem.totalRating = product.totalRating!  as NSNumber?
            savedItem.retailPrice = product.retailPrice!
            savedItem.productTypeName = product.productTypeName
            savedItem.productReleaseDate = product.productReleaseDate
            savedItem.productRating = product.productRating as NSNumber?
            savedItem.productModelNumber = product.productModelNumber
            savedItem.productCollection = product.productCollection
            savedItem.productCatagory = product.productCatagory
            savedItem.id = product.id
            savedItem.euroSize = product.euroSize
            savedItem.color = product.color
            savedItem.collectionName = product.collectionName
            savedItem.catagoryName = product.catagoryName
            
            saveContext()
        }
        
    }
    
    func deleteProduct(id : String){
        
        if let item : Product = fetchProductForID(id: id){
            coreData.managedObjectContext?.delete(item)
            saveContext()
        }
        
    }
    
}
