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
    
    
    
    
    static func timelineRequestforCurrentUserWithOptions(range: Range<Int>, isFriendPost: Bool, category: Int, completionBlock: PFArrayResultBlock) {
        let query = Post.query()
        if let query=query{
            if(!isFriendPost){
                // get public posts
                query.whereKey(PF_POST_ISPRIVATE, equalTo: false)
            }else if (isFriendPost){
                // friends
          
            let friendsQuery = PFQuery(className:PF_FRIEND_CLASS_NAME)
            friendsQuery.whereKey(PF_FRIEND_USER, equalTo:PFUser.currentUser()!)
            query.whereKey(PF_POST_POSTER, matchesKey: PF_FRIEND_FRIEND, inQuery: friendsQuery)
            
                
            }
            
            query.includeKey(PF_POST_POSTER)
            query.orderByDescending(PF_POST_CREATEDAT)
            //only show some range not all
            query.skip = range.startIndex
            query.limit = range.endIndex - range.startIndex
            query.findObjectsInBackgroundWithBlock(completionBlock)
        
        }
        
            
    }

    
    
    static func timelineRequestforCurrentUserWithCategory(range: Range<Int>, categoryIndex: Int, completionBlock: PFArrayResultBlock) {
        
        let categorys = ["technology","travelling","fashion","pet","food","others"]
        
        let query = Post.query()
        if let query=query{
            //println("category:\(categorys[categoryIndex])")
            query.whereKey(PF_POST_CATEGORY, equalTo: categorys[categoryIndex])
            query.includeKey(PF_POST_POSTER)
            query.orderByDescending(PF_POST_CREATEDAT)
            //only show some range not all
            query.skip = range.startIndex
            query.limit = range.endIndex - range.startIndex
            query.findObjectsInBackgroundWithBlock(completionBlock)
            
        }
        
        
    }

    
    
    static func timelineRequestforCurrentUserWithFriend(range: Range<Int>, user: PFUser, completionBlock: PFArrayResultBlock) {
   
        let query = Post.query()
        if let query=query{
            query.whereKey(PF_POST_POSTER, equalTo: user)
            query.includeKey(PF_POST_POSTER)
            query.orderByDescending(PF_POST_CREATEDAT)
            //only show some range not all
            query.skip = range.startIndex
            query.limit = range.endIndex - range.startIndex
            query.findObjectsInBackgroundWithBlock(completionBlock)
            
        }
        
        
    }

    
    
    
    
    static func timelineRequestforCurrentUserFriends(completionBlock: PFArrayResultBlock){
        
        let friendsQuery = PFQuery(className:PF_FRIEND_CLASS_NAME)
        friendsQuery.whereKey(PF_FRIEND_USER, equalTo:PFUser.currentUser()!)
        let query = Post.query()
        if let query=query{
            query.whereKey(PF_POST_POSTER, matchesKey: PF_FRIEND_FRIEND, inQuery: friendsQuery)
            query.includeKey(PF_POST_POSTER)
            query.orderByDescending(PF_POST_CREATEDAT)
            
            query.findObjectsInBackgroundWithBlock(completionBlock)
            
            
        }

        
    }

    static func timelineRequestforCurrentUserOwn(range: Range<Int>, completionBlock: PFArrayResultBlock) {
        
        let query = Post.query()
        if let query=query{
            query.whereKey(PF_POST_POSTER, equalTo: PFUser.currentUser()!)
            query.includeKey(PF_POST_POSTER)
            query.orderByDescending(PF_POST_UPDATEDAT)
            
            //only show some range not all
            query.skip = range.startIndex
            query.limit = range.endIndex - range.startIndex
            query.findObjectsInBackgroundWithBlock(completionBlock)
     
        }
    }

    // MARK: Friends
    static func allFriends(completionBlock: PFArrayResultBlock){
        var query=PFQuery(className: PF_FRIEND_CLASS_NAME)
        query.whereKey(PF_FRIEND_USER, equalTo: PFUser.currentUser()!)
        query.includeKey(PF_FRIEND_FRIEND)
        query.limit=50
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
    }
    
    static func getFriendsNum(completionBlock: PFArrayResultBlock){
        var query=PFQuery(className: PF_FRIEND_CLASS_NAME)
        query.whereKey(PF_FRIEND_USER, equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func addFriendFromUserToUser(fromUser:PFUser, toUser: PFUser){
        
        let friendRelation=PFObject(className: PF_FRIEND_CLASS_NAME)
        friendRelation[PF_FRIEND_USER]=fromUser
        friendRelation[PF_FRIEND_FRIEND]=toUser
        friendRelation.saveInBackgroundWithBlock{(success:Bool, error:NSError?) -> Void in
            if error != nil{
                println("Parse Helper add friend error: \(error)")
                UICustomSettingHelper.sweetAlertNetworkError()
            }
            
            if (success) {
               // SweetAlert().showAlert("Add friend!", subTitle: "Add a friend Successfully!", style: AlertStyle.Success)
            }
        }
    }
    
    static func hasFriendRelation(user1: PFUser, user2: PFUser, completionBlock: PFArrayResultBlock){
        
        let query=PFQuery(className: PF_FRIEND_CLASS_NAME)
        query.whereKey(PF_FRIEND_USER, equalTo: user1)
        query.whereKey(PF_FRIEND_FRIEND, equalTo: user2)
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
    }
    
    static func removeFriend(user:PFUser, completionBlock: PFArrayResultBlock){
        let queryRelation1=PFQuery(className: PF_FRIEND_CLASS_NAME)
        // delete relations
        queryRelation1.whereKey(PF_FRIEND_FRIEND, equalTo: user)
        queryRelation1.whereKey(PF_FRIEND_USER, equalTo: PFUser.currentUser()!)
        
        let queryRelation2=PFQuery(className: PF_FRIEND_CLASS_NAME)
        queryRelation2.whereKey(PF_FRIEND_FRIEND, equalTo: PFUser.currentUser()!)
        queryRelation2.whereKey(PF_FRIEND_USER, equalTo:user)
        
        let mainQuery=PFQuery.orQueryWithSubqueries([queryRelation1,queryRelation2])
        mainQuery.findObjectsInBackgroundWithBlock(completionBlock)
        
    
    }
    
    static func removeFriend(fromUser:PFUser,toUser:PFUser){
        let query=PFQuery(className: PF_FRIEND_CLASS_NAME)
        query.whereKey(PF_FRIEND_USER, equalTo: fromUser)
        query.whereKey(PF_FRIEND_FRIEND, equalTo: toUser)
        query.findObjectsInBackgroundWithBlock{ (results:[AnyObject]? , error: NSError?) -> Void in
            
            if let results=results as? [PFObject]{
                var num=results.count;
                println(" friendRelation num:\(num)")
                while(num>1){
                    var index=num-1;
                    if(index>=0 && index<results.count){
                        var friendRelation=results[index]
                        friendRelation.deleteInBackgroundWithBlock{ (success:Bool, error:NSError?) -> Void in
                            if(error != nil){
                                println("remove duplicate friend relation error : \(error)")
                            }
                            
                        }
                    }
                    
                    num--;
                }
                
            }
            
        }
        
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
    
    //MARK: Post
    
    static func findPostWithPostId(postId:String ,completionBlock: PFArrayResultBlock){
        var query=PFQuery(className: PF_POST_CLASS_NAME)
        
        query.whereKey("objectId", equalTo: postId)
        query.includeKey(PF_POST_POSTER)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    
    static func deletePostWithPostId(postId:String, completionBlock:PFBooleanResultBlock ){
        // delete post
        var queryPost=PFQuery(className: PF_POST_CLASS_NAME)
        queryPost.whereKey("objectId", equalTo: postId)
        queryPost.findObjectsInBackgroundWithBlock{(results:[AnyObject]? , error: NSError?) -> Void in
        
            if  let results=results as? [Post]{
                for result in results{
                   result.deleteInBackgroundWithBlock(completionBlock)
                }
            }
            
        }
        
        // delete related votes
     
        var queryVote=PFQuery(className: PF_VOTE_CLASS_NAME)
        queryVote.whereKey(PF_VOTE_POSTID, equalTo: postId)
        queryVote.findObjectsInBackgroundWithBlock{(results:[AnyObject]? , error: NSError?) -> Void in
            
            if  let results=results as? [PFObject]{
                 println("remove vote: \(results.count)")
                for result in results{
                    result.deleteInBackgroundWithBlock{ (success:Bool , error:NSError?) -> Void in
                        if error != nil {
                            println("ParseHelper: deleteInBackgroundWithBlock \(error)")
                        }
                }
             }
           }
        }
        
        //delete related comments
        var queryComment=PFQuery(className: PF_COMMENT_CLASS_NAME)
        queryComment.whereKey(PF_COMMENT_GROUPID, equalTo: postId)
        queryComment.findObjectsInBackgroundWithBlock{(results:[AnyObject]? , error: NSError?) -> Void in
            
            if  let results=results as? [PFObject]{
                println("remove comment: \(results.count)")
                for result in results{
                    result.deleteInBackgroundWithBlock{ (success:Bool , error:NSError?) -> Void in
                        if error != nil {
                            println("ParseHelper: deleteInBackgroundWithBlock \(error)")
                        }
                    }
                }
            }
        }

        
        
    }
    
  
    static func getNumOfPostsOfUser(user:PFUser ,completionBlock: PFArrayResultBlock){
        let query = Post.query()
        if let query=query{
            query.whereKey(PF_POST_POSTER, equalTo: user)
            query.includeKey(PF_POST_POSTER)
            query.orderByDescending(PF_POST_CREATEDAT)
            
            query.findObjectsInBackgroundWithBlock(completionBlock)
        }

    }
    
   
    
    //MARK: Vote
    
    
    
    static func findVotesWithPostId(postId:String ,completionBlock: PFArrayResultBlock){
        var query=PFQuery(className: PF_VOTE_CLASS_NAME)
        query.whereKey(PF_VOTE_POSTID, equalTo: postId)
        query.includeKey(PF_VOTE_VOTER)
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
    }
    
    static func timelineRequestfindVotesWithPostId(range: Range<Int>, postId:String, completionBlock: PFArrayResultBlock) {
        
        var query=PFQuery(className: PF_VOTE_CLASS_NAME)
        query.whereKey(PF_VOTE_POSTID, equalTo: postId)
        query.includeKey(PF_VOTE_VOTER)
        query.orderByDescending(PF_VOTE_CREATEDAT)
        //only show some range not all
        query.skip = range.startIndex
        query.limit = range.endIndex - range.startIndex

        query.findObjectsInBackgroundWithBlock(completionBlock)

    }

    
    
    static func isUserVotedForPost(postId:String ,completionBlock: PFArrayResultBlock){

        var query=PFQuery(className: PF_VOTE_CLASS_NAME)
        
        query.whereKey(PF_VOTE_VOTER, equalTo: PFUser.currentUser()!)
        
        query.whereKey(PF_VOTE_POSTID, equalTo: postId)
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
     }
    
    static func saveVote(postId:String, choice:Int){
        
        var vote = PFObject(className: PF_VOTE_CLASS_NAME)
        vote[PF_VOTE_VOTER]=PFUser.currentUser()!
        vote[PF_VOTE_POSTID]=postId
        vote[PF_VOTE_CHOICE]=choice
        
        vote.saveInBackgroundWithBlock{ (success:Bool, error:NSError?) -> Void in
            
            if(error != nil){
                if error != nil{
                    UICustomSettingHelper.sweetAlertNetworkError()
                }

                println("ParseHelper, save vote error:\(error)")
            }
        }
    }
    
    static func updatePostStatistic(postId:String, choice:Int,completionBlock: PFBooleanResultBlock ){
       var query=PFQuery(className: PF_POST_CLASS_NAME)
       query.whereKey("objectId", equalTo: postId)
    
        query.findObjectsInBackgroundWithBlock{(results:[AnyObject]?, error: NSError?) -> Void in
            
            if var results = results as? [PFObject]{
                
                //in case some post are saved several times
                for result in results {
                    if result[PF_POST_TOTALVOTES]==nil{
                        
                        result[PF_POST_TOTALVOTES] = 1
                        
                    }else{
                       var total=result[PF_POST_TOTALVOTES] as! Int
                       total++
                       result[PF_POST_TOTALVOTES]=total
                    }
                
                    // in case vote1 and vote2 are not initialized
                    if result[PF_POST_VOTE1] == nil{
                        result[PF_POST_VOTE1]=0;
                    }
                    
                    if result[PF_POST_VOTE2] == nil{
                        result[PF_POST_VOTE2]=0;
                    }

          
                    
                    // update vote choice
                    if choice==1{
                      
                        var vote1=result[PF_POST_VOTE1] as! Int
                       
                        vote1++
                        result[PF_POST_VOTE1]=vote1
                     
                        
                    }else if choice==2{
                      
                        var vote2=result[PF_POST_VOTE2] as! Int
                    
                        vote2++
                        result[PF_POST_VOTE2]=vote2
                 
                    }
                   
                    result.saveInBackgroundWithBlock(completionBlock)
                    
                  
                }
                
            }
        }
    }
    
    
    // MARK: comment 
    static func getCommentNumberWithPostId(postId: String, completionBlock: PFArrayResultBlock){
        var query = PFQuery(className: PF_COMMENT_CLASS_NAME)
        query.whereKey(PF_COMMENT_GROUPID, equalTo: postId )
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
    }
    
    // MARK: containMethods
    static func  parseContains( array:[PFObject], object: PFObject) -> Bool{
        
        for element in array {
            if(element.objectId == object.objectId){
                return true
            }
        }
        
        return false
        
    }
    
    static func parseGetObjectIndexFromArray( array:[PFObject], object: PFObject) -> Int{
    
        for (var index=0; index<array.count; index++) {
            
           // println("\(array[index].objectId) , \(object.objectId)")
            
            if(array[index].objectId == object.objectId){
                return index
            }
        }
        
        return -1
        
    }

    
    
    // MARK: get userImage
    
    static func getUserImage(user: PFUser?, completionBlock: PFDataResultBlock){
        if let user=user{
        var imageFile=user[PF_USER_PICTURE] as? PFFile
            if let imageFile=imageFile{
                imageFile.getDataInBackgroundWithBlock(completionBlock)
            }
            
        }
    }
    
    
    // MARK: add Friends requests
    static func getFriendsRequest(completionBlock: PFArrayResultBlock){
        var query=PFQuery(className: PF_FRIENDSREQUEST_CLASS_NAME)
        query.whereKey(PF_FRIENDSREQUEST_TOUSER, equalTo: PFUser.currentUser()!)
        query.includeKey(PF_FRIENDSREQUEST_FROMUSER)
        query.orderByDescending(PF_FRIENDSREQUEST_CREATEDAT)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    
    static func removeFriendRequestFromUser(fromUser:PFUser, completionBlock:PFArrayResultBlock){
        
        var query=PFQuery(className: PF_FRIENDSREQUEST_CLASS_NAME)
        query.whereKey(PF_FRIENDSREQUEST_FROMUSER, equalTo: fromUser)
        query.findObjectsInBackgroundWithBlock(completionBlock)

    }
    
    static func saveAddFriendRequest(toUser:PFUser, message: String?,completionBlock: PFBooleanResultBlock){
        
        var request=PFObject(className: PF_FRIENDSREQUEST_CLASS_NAME)
        request[PF_FRIENDSREQUEST_FROMUSER]=PFUser.currentUser()!
        request[PF_FRIENDSREQUEST_TOUSER]=toUser
        request[PF_FRIENDSREQUEST_MESSAGE]=message
        
        request.saveInBackgroundWithBlock(completionBlock)
   
    }

    
    // MARK: parse vote and comment Notification
    static func uploadNotification(fromUser:PFUser, toUser:PFUser, messageType:String, post: Post){
        
        var notification=PFObject(className: PF_NOTIFICATION_CLASS_NAME)
        notification[PF_NOTIFICATION_FROMUSER]=fromUser
        notification[PF_NOTIFICATION_TOUSER]=toUser
        notification[PF_NOTIFICATION_MESSAGETYPE]=messageType
        notification[PF_NOTIFICATION_POST]=post
        
        notification.saveInBackgroundWithBlock{(success:Bool, error: NSError?) -> Void in
            
            if(success){
              //  println("save notification successfully")
            }
        }
        
    }
    
    static func getAllNotificationsOfCurrentUser(completionBlock:PFArrayResultBlock){
        var query=PFQuery(className: PF_NOTIFICATION_CLASS_NAME)
        query.whereKey(PF_NOTIFICATION_TOUSER, equalTo: PFUser.currentUser()!)
        query.includeKey(PF_NOTIFICATION_FROMUSER)
        query.includeKey(PF_NOTIFICATION_POST)
        query.orderByDescending(PF_NOTIFICATION_CREATEDAT)
        query.limit=50
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    
    static func updateProfileTabBadgeValue(controller:UITabBarController){
        
        var items=controller.tabBar.items
        
        if let items=items{
            var item=items[3] as! UITabBarItem
            
            //friends request + vote and comment notifications
            var num=0
            ParseHelper.getFriendsRequest{ (results:[AnyObject]?, error:NSError?) -> Void in
                if let results=results{
                    num=results.count
                    var currentInstallation=PFInstallation.currentInstallation()
                    num=num+currentInstallation.badge
                    //println("item badgeValue:\(num)")
                    if(num != 0){
                        item.badgeValue="\(num)"
                        
                    }else{
                        item.badgeValue=nil
                    }
                    
                    
                }
                
            }
            
            
        }
    }

    
    
}