//
//  Post.swift
//  Makestagram
//
//  Created by 吴梦宇 on 6/28/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import Parse
import Bond
import ConvenienceKit

//Parse framework will be able to use that class as the native class for a Parse cloud object.

class Post: PFObject, PFSubclassing {
    @NSManaged var image1File: PFFile?
    @NSManaged var image2File: PFFile?
    @NSManaged var poster: PFUser?
    @NSManaged var title: String
    @NSManaged var isPrivate: Bool
    @NSManaged var totalVotes: Int
    @NSManaged var vote1: Int
    @NSManaged var vote2: Int

    
    // var image: UIImage?
    //That wrapper allows us to listen for changes to the wrapped value. The Dynamic wrapper enables us to use the property together with bindings.
    // we need to append .value to access the value wrapped by the Dynamic
    var image1: Dynamic<UIImage?> = Dynamic(nil)
    var image2: Dynamic<UIImage?> = Dynamic(nil)
    
    var totalVotesInt: Dynamic<Int!> = Dynamic(nil)
    var vote1Int: Int!
    var vote2Int: Int!

    var vote1Percentage: Dynamic<String!> = Dynamic(nil)
    var vote2Percentage: Dynamic<String!> = Dynamic(nil)
    
    
    // define static var imageCache so that imageCache can be accessed without create an instance, you can get it from Post.imageCache
    
    //. We define it as static, because the cache does not belong to a particular instance of the Post class, but is instead shared between all posts.
    
    static var image1Cache:NSCacheSwift<String,UIImage>!
    static var image2Cache:NSCacheSwift<String,UIImage>!
    
    var photoUploadTask: UIBackgroundTaskIdentifier?
    
    //MARK: PFSubcalssing Protocol
    
    static func parseClassName() -> String {
        return "Post"
    }
    
    override init(){
        super.init()
    }
    
    override class func initialize(){
        
        var onceToken : dispatch_once_t = 0 ;
        dispatch_once(&onceToken){
            // inform parse about this subclass
            self.registerSubclass()
            // 1
            Post.image1Cache = NSCacheSwift<String, UIImage>()
            Post.image2Cache = NSCacheSwift<String, UIImage>()
        }
        
    }
    
    
    func downloadImage(){
        
        // put in cache
        image1.value = Post.image1Cache[self.image1File!.name]
        image2.value = Post.image1Cache[self.image2File!.name]
        
        if(image1.value == nil){
            
            image1File?.getDataInBackgroundWithBlock{(data: NSData?, error: NSError?) -> Void in
                
                if let error = error {
                   // ErrorHandling.defaultErrorHandler(error)
                    println("error")
                }
                
                if let data = data {
                    
                    let image1 = UIImage(data:data, scale: 1.0)!
                    
                    self.image1.value=image1
                    
                    Post.image1Cache[self.image1File!.name]=image1
                    
                }
  
            }
            
        }
        
        if(image2.value == nil){
            
            image2File?.getDataInBackgroundWithBlock{(data: NSData?, error: NSError?) -> Void in
                
                if let error = error {
                    // ErrorHandling.defaultErrorHandler(error)
                    println("error")
                }
                
                if let data = data {
                    
                    let image2 = UIImage(data:data, scale: 1.0)!
                    
                    self.image2.value=image2
                    
                    Post.image2Cache[self.image1File!.name]=image2
                    
                }
                
            }
            
        }

    }
    
    
    func getPostStatistic(){
        
        self.totalVotesInt.value=self.totalVotes ?? 0
        self.vote1Int=self.vote1 ?? 0
        self.vote2Int=self.vote2 ?? 0
        
        // percentage:
        if(self.totalVotesInt.value==0){
            self.vote1Percentage.value=" 0 %"
            self.vote2Percentage.value=" 0 %"
        }else{
            var p1 = Float(self.vote1Int)/Float(self.totalVotesInt.value)*100
            var p2 = Float(self.vote2Int)/Float(self.totalVotesInt.value)*100
            
            self.vote1Percentage.value=" \(p1) %"
            self.vote2Percentage.value=" \(p2) %"
            
        }
        
    }
    
    
    func uploadPost(){
        let image1Data=UIImageJPEGRepresentation(image1.value, 0.8)
        let image1File=PFFile(data: image1Data)
        
        let image2Data=UIImageJPEGRepresentation(image2.value, 0.8)
        let image2File=PFFile(data: image2Data)
        
        //1. create a background task,Marks the beginning of a new long-running background task.
        photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler{() -> Void in
            //A handler to be called shortly before the app’s remaining background time reaches 0.
            // when the time is expired, shoudl also delete this task
            //Marks the end of a specific long-running background task.
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
        }
        
        
        image1File.saveInBackgroundWithBlock{
            (success: Bool, error: NSError? ) -> Void in
            
            if let error = error {
               // ErrorHandling.defaultErrorHandler(error)
                println("error")
            }
            
            // when imageFile is saved successfully we can delete this task
           // UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
        }
        
        image2File.saveInBackgroundWithBlock{
            (success: Bool, error: NSError? ) -> Void in
            
            if let error = error {
                // ErrorHandling.defaultErrorHandler(error)
                println("error")
            }
            
            // when imageFile is saved successfully we can delete this task
           // UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
        }

        self.image1File=image1File
        self.image2File=image2File
        self.poster = PFUser.currentUser()
        self.totalVotes=0;
        self.vote1=0;
        self.vote2=0;
        
      //  saveInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
        saveInBackgroundWithBlock(nil)
        
    }
    
  
    
}
