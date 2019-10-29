//
//  StatesCountyPicker.swift
//  Swagafied
//
//  Created by Amitabha on 14/01/17.
//  Copyright © 2017 Amitabha Saha. All rights reserved.
//

import Foundation
import SwiftyJSON

class StatesCountyModel{
    
    var USAJson: JSON!
    var fileName = "USstates_city"
    var statesDictionary: Array<(String, Array<Any>)> = Array<(String, Array<Any>)>()
    typealias completionHandler = ()->()
    
    func loadDataSource( completion: completionHandler?){
        
        // Load data from local json file & configure data source
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            
            do {
                
                // Load Data type object from local json file
                let data = try NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                
                // Serialize data object into JSON object
                USAJson = JSON(data: data as Data)
                
                for (key,subJson):(String, JSON) in USAJson {
                    //Do something you want
                    let cities = subJson.arrayValue
                    statesDictionary.append((key,cities))
                }
                //sorted(statesDictionary) { $0.0 < $1.0 }
                completion?()
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        } else {
            print("Invalid filename/path.")
        }
    }
}
