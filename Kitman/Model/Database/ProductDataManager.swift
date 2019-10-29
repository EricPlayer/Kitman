//
//  ProductAdaptar.swift
//  Swagafied
//
//  Created by Amitabha on 13/02/17.
//  Copyright © 2017 Amitabha Saha. All rights reserved.
//

// This class is responsible for inserting all data to DB and reading out all data back from DB. All DB realted operation it should handle

import Foundation
import ObjectMapper
import SwiftyJSON

class ProductDataManager {
    
    var internalCache: [ProductObject]?
    
    var dataSource: [ProductObject]?{
        get{
            return self.fetchDataSouceFromDataBase()
        }
    }
    
//    var dataSource: [ProductObject]?{
//        get{
//            return self.fetchDataSouceFromDataBase()
//        }set{
//            saveData()
//        }
//    }
    
    static let sharedManager = ProductDataManager()
    
    func isDataSaved() -> Bool{
        
        if let managedObjectList : [Product] = DatabaseHelper.sharedHelper.fetchProductList(){
            
            if managedObjectList.count > 0{
                return true
            }else{
                return false
            }
        }
        
        return false
        
    }
    
    private func fetchDataSouceFromDataBase() -> [ProductObject]?{
        
        guard let cachedata = internalCache else {
            
            // Get data from cache
            if let managedObjectList : [Product] = DatabaseHelper.sharedHelper.fetchProductList(){
                
                internalCache = [ProductObject]()
                
                for item in managedObjectList{
                    
                    // convert MO to dataModel
                    let responseObject: [String: Any] = [String: Any]()
                    
                    let modelItem = Mapper<ProductObject>().map(JSON: responseObject)
                    modelItem?.convertToModelFromCoreData(item: item)
                    
                    internalCache?.append(modelItem!)
                }
                
                return internalCache
                
            }else{
                // No data found
                return nil
            }
            
        }
        return cachedata
    }
    
    func saveData(){
        
        if let object = readJson(){
            // json is a dictionary
            let responseLocalObject = Mapper<ProductResponse>().map(JSON: object)
            let dataArray : [ProductObject] = (responseLocalObject?.products)!
            
            for item in dataArray{
                
                let _ = DatabaseHelper.sharedHelper.insertProduct(item: item)
                
            }
        }
        
    }
    
    func saveData( dataObjects: [ProductObject] ){
        
        if let object = readJson(){
            // json is a dictionary
            let responseLocalObject = Mapper<ProductResponse>().map(JSON: object)
            let dataArray : [ProductObject] = (responseLocalObject?.products)!
            
            for item in dataObjects{
                
                let _ = DatabaseHelper.sharedHelper.insertProduct(item: item)
                
            }
        }
        
    }
    
    private func readJson() -> [String: Any]?{
        do {
            if let file = Bundle.main.url(forResource: "products", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    return object
                } else if json is [Any] {
                    // json is an array
                    return nil
                } else {
                    print("JSON is invalid")
                    return nil
                }
            } else {
                print("no file")
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

