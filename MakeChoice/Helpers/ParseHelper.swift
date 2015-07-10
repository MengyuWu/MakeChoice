//
//  ParseHelper.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/9/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import Foundation
import Parse

class ParseHelper{
    
    
    //We mark this method as static. This means we can call it without having to create an instance of ParseHelper - you should do that for all helper methods.
    
    // The type of this parameter is PFArrayResultBlock. That's the default type for all of the callbacks in the Parse framework. By taking this callback as a parameter, we can call any Parse method and return the result of the method to that completionBlock
    static func timelineRequestforCurrentUserPublic(range: Range<Int>, completionBlock: PFArrayResultBlock) {

        let query = Post.query()
        if let query=query{
        query.includeKey(PF_POST_POSTER)
        query.orderByDescending(PF_POST_CREATEDAT)
        
        //only show some range not all
        query.skip = range.startIndex
        query.limit = range.endIndex - range.startIndex
        query.findObjectsInBackgroundWithBlock(completionBlock)
            

        }
   }
    

    // MARK: image background, and conner radius set up
    static func setCircleImage(image:UIImageView){
       // image.backgroundColor=UIColor.blueColor()
        image.layer.cornerRadius=image.frame.size.width / 2
        image.clipsToBounds=true
    }

    
    // MARK: Users
    
    /**
    Fetch all users, except the one that's currently signed in.
    Limits the amount of users returned to 20.
    
    :param: completionBlock The completion block that is called when the query completes
    
    :returns: The generated PFQuery
    */
    
    static func allUsers(completionBlock: PFArrayResultBlock) -> PFQuery {
        
        let query=PFUser.query()!
        query.whereKey(PF_USER_USERNAME, notEqualTo: PFUser.currentUser()!.username!)
        query.orderByAscending(PF_USER_USERNAME)
        query.limit=20
        
        query.findObjectsInBackgroundWithBlock(completionBlock) // return the PFObject
        
        return query
        
    }
    
    /**
    Fetch users whose usernames match the provided search term.
    
    :param: searchText The text that should be used to search for users
    :param: completionBlock The completion block that is called when the query completes
    
    :returns: The generated PFQuery
    */
    
    static func searchUsers(searchText: String, completionBlock: PFArrayResultBlock)-> PFQuery {
        /*
        NOTE: We are using a Regex to allow for a case insensitive compare of usernames.
        Regex can be slow on large datasets. For large amount of data it's better to store
        lowercased username in a separate column and perform a regular string compare.
        */
        
        let query=PFUser.query()!
        
        query.whereKey(PF_USER_USERNAME, matchesRegex: searchText, modifiers: "i") //"i " means case insensitive
        query.whereKey(PF_USER_USERNAME, notEqualTo: PFUser.currentUser()!.username!)
        
        query.orderByAscending(PF_USER_USERNAME)
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
        return query
        
    }
    
    
}