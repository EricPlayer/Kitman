//
//  ImageDownloader.swift
//  Swagafied
//
//  Created by Amitabha on 19/09/16.
//  Copyright © 2016 Amitabha Saha. All rights reserved.
//

import Foundation

class ImageDownloaderManager: NSObject {
    
    var downloadAllImage = false
    var idx = 0
    var currentIndex = 0
    let totalImageSetCount = Configuration.ImagedownloadSettings.imageCountInSet
    typealias ImageDownloadCallBack = ((_ index : Int, _ success : Bool)->())
    var completionHandler: ImageDownloadCallBack?
    
    static let sharedImageDownloaderManager = ImageDownloaderManager()
    var downloadedIndex : Int {
        get{
            return UserDefaults.standard.integer(forKey: "downloadedIndex")
        }
        set(aNewValue){
            UserDefaults.standard.set(aNewValue, forKey: "downloadedIndex")
        }
    }
    
    var mainImageURLs : Array<String> = Array<String>()
    
    func downloadImage(){
        downloadAllImage = true
        downloadNextSetImage()
    }
    
    func downloadNextSetImage() {
        
        let fromIndex = downloadedIndex
        let toIndex = (downloadedIndex+totalImageSetCount-1) > (mainImageURLs.count-1) ? mainImageURLs.count-1 : (downloadedIndex+totalImageSetCount)-1
        
        let imageURLSet  = mainImageURLs[fromIndex...toIndex]
        currentIndex = 0
        downloadFromArray( imageURLSet: Array(imageURLSet) )
    }
    
    func downloadFromArray( imageURLSet : Array<String>){
        
        if currentIndex < imageURLSet.count{
            
            var urlString = imageURLSet[currentIndex]
            var imageNameKey = urlString.replacingOccurrences(of: " ", with: "_")
            imageNameKey = getImageNameFromURLString(urlString: imageNameKey) ?? "IMG_NONAME"
            urlString = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
    
            let imagePath = fileInDocumentsDirectory(filename: "Image_\(imageNameKey)")
            
            // Check the file exists or not
            if FileManager.default.fileExists(atPath: imagePath) == false{
                
                // Download image
                downloadImage( url: URL(string: urlString)! , completionBlock: { (image,success) in
                    if(success){
                        
                        // Save image object in Doc Dir
                        if let imageD = image{
                            
                            if let imageData = UIImageJPEGRepresentation(imageD ,0.9){
                                
                                do {
                                    try imageData.write(to: NSURL(string: "file://"+imagePath)! as URL, options: .atomic)
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    }
                    else{
                        print("Failed - \(self.downloadedIndex+self.idx+1) : URL : \(urlString)")
                    }
                    
                    self.currentIndex = self.currentIndex+1
                    if self.currentIndex == imageURLSet.count-1{
                        self.downloadedIndex = self.downloadedIndex + self.currentIndex
                        if let completionHandler = self.completionHandler{
                            completionHandler(self.downloadedIndex,true)
                        }
                    }else{
                        self.downloadFromArray(imageURLSet: imageURLSet)
                    }
                    
                })
                
            }
            else{
                self.currentIndex = self.currentIndex+1
                if self.currentIndex == imageURLSet.count-1{
                    self.downloadedIndex = self.downloadedIndex + self.currentIndex
                    if let completionHandler = self.completionHandler{
                        completionHandler(self.downloadedIndex,true)
                    }
                }else{
                    self.downloadFromArray(imageURLSet: imageURLSet)
                }
            }
        }
        
        /*
 
        if(idx < (imageURLSet.count) && downloadedIndex+1 < mainImageURLs.count){
            
            var urlString = imageURLSet[idx]
            
            var imageNameKey = urlString.replacingOccurrences(of: " ", with: "_")
            imageNameKey = getImageNameFromURLString(urlString: imageNameKey) ?? "IMG_NONAME"
            
            urlString = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!

            
            let imagePath = fileInDocumentsDirectory(filename: "Image_\(imageNameKey)")
            
            // Check the file exists or not
            if FileManager.default.fileExists(atPath: imagePath) == false{
                
                // Download image
                downloadImage( url: URL(string: urlString)! , completionBlock: { (image,success) in
                    
                    if(success){
                        
                        // Save image object in Doc Dir
                        if let imageD = image{
                            
                            if let imageData = UIImageJPEGRepresentation(imageD ,0.9){
                                
                                do {
                                    try imageData.write(to: NSURL(string: "file://"+imagePath)! as URL, options: .atomic)
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    }
                    else{
                        print("Failed - \(self.downloadedIndex+self.idx+1) : URL : \(urlString)")
                    }
                    
                    self.idx = self.idx+1
                    if self.idx == imageURLSet.count{
                        
                        self.downloadedIndex = self.downloadedIndex + (self.idx - 1)
                        
                        if self.downloadedIndex != self.mainImageURLs.count-1{
                            self.idx = 0
                            if self.downloadAllImage{
                                self.downloadImage()
                            }
                        }else{
                            self.downloadedIndex = self.mainImageURLs.count-1
                            return
                        }
                        
                    }else{
                        
                        self.downloadFromArray(imageURLSet: imageURLSet)
                    }
                    
                })
            }
            else{
                
                self.idx = self.idx+1
                if self.idx == imageURLSet.count{
                    
                    self.downloadedIndex = self.downloadedIndex + (self.idx - 1)
                    
                    if self.downloadedIndex != self.mainImageURLs.count-1{
                        self.idx = 0
                        if self.downloadAllImage{
                            self.downloadImage()
                        }
                    }else{
                        self.downloadedIndex = self.mainImageURLs.count-1
                        return
                    }
                    
                }else{
                    
                    print("Already Saved - \(self.downloadedIndex+self.idx+1)")
                    self.downloadFromArray(imageURLSet: imageURLSet)
                }
                
            }
        }
        else{
            print("else_condition")
            if let completionHandler = completionHandler{
                completionHandler(downloadedIndex,true)
            }
        }
 
         */
    }
    
    func downloadImage(url : URL , indexpath : IndexPath? = nil, completionBlock: @escaping ((_ image : UIImage?, _ success : Bool)->())){
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            
            let imageData = NSData(contentsOf:url as URL )
            DispatchQueue.main.async {
                if let image = imageData{
                    completionBlock(UIImage(data:image as Data)! ,true)
                }else{
                    completionBlock(nil ,false)
                }
            }
        }
    }
}

extension ImageDownloaderManager{
    
    func getImageNameFromURLString(urlString : String) -> String?{
        
        let slices = urlString.components(separatedBy: "/")
        return slices.last
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func fileInDocumentsDirectory(filename: String) -> String {
        
        let fileURL = getDocumentsDirectory().appendingPathComponent("ImageFolder").appendingPathComponent(filename)
        return fileURL.path
        
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: \(path)")
        }
        print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }
    
}

