//
//  HomeViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/9/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit
import ConvenienceKit

class HomeViewController: UIViewController,TimelineComponentTarget {
    
  
    @IBOutlet weak var tableView: UITableView!
    
    // implement timelineComponentTarget
    // angled brackets: the type of object you are displaying (Post) and the class that will be the target of the TimelineComponent (that's the TimelineViewController in our case).
    var timelineComponent:TimelineComponent<Post, HomeViewController>!
   
    let defaultRange = 0...4
    let additionalRangeSize = 5
    
    var friendPosts:[Post]=[]
    
    var isFriendPost=false
    
    var selectedCommentIndex:Int?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func indexChanged(sender: AnyObject) {
        
        switch segmentedControl.selectedSegmentIndex
        {
            
        case 0:
            NSLog("Public")
            isFriendPost=false
            timelineComponent.refresh(self)
            
        case 1:
            NSLog("Friends")
            isFriendPost=true
            timelineComponent.refresh(self)
           
        default:
            break;
        }

    }
    
   
    
  
    
    
    /**
    This method should load the items within the specified range and call the
    `completionBlock`, with the items as argument, upon completion.
    */
    func loadInRange(range: Range<Int>, completionBlock: ([Post]?) -> Void){
        if(isFriendPost){
            ParseHelper.timelineRequestforCurrentUserWithOptions(range,isFriendPost:true, category:0){ (result: [AnyObject]?, error: NSError?) -> Void in
                let posts = result as? [Post] ?? []
                completionBlock(posts)
            }
        }else{
            ParseHelper.timelineRequestforCurrentUserWithOptions(range,isFriendPost:false, category:0){ (result: [AnyObject]?, error: NSError?) -> Void in
                let posts = result as? [Post] ?? []
                completionBlock(posts)
            }
   
        }
        
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.delegate=self
        self.tableView.dataSource=self
        timelineComponent = TimelineComponent(target: self)
        
        //assign the installation[user] to be current user
         PushNotication.parsePushUserAssign()
        
        timelineComponent.refresh(self)
        
      
    }
    
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       // timelineComponent.refresh(self)
        if var tabBarController=self.navigationController?.tabBarController as? RAMAnimatedTabBarController{
            //hide the TabBar in comment view controller
           // tabBarController.hidesBottomBarWhenPushed=false
            println(tabBarController.iconsView.count)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if( segue.identifier=="commentPushSegue"){
            let commentVC = segue.destinationViewController as! CommentViewController
            
            // commentVC.hidesBottomBarWhenPushed = true
            
            if let post=sender as? Post{
                let groupId = post.objectId! as String ?? ""
                commentVC.groupId = groupId
                commentVC.post=post
                commentVC.index=self.selectedCommentIndex
            }
            

        }
    }
    
    
    // MARK:unwind segue
    @IBAction func unwindToSegue(segue: UIStoryboardSegue){
        if let identifier = segue.identifier {
            
            if (identifier=="commentUnwind") {
                println("commentUnwind")
                if(segue.sourceViewController .isKindOfClass(CommentViewController)){
                    var commentVC=segue.sourceViewController as! CommentViewController
                    
                    var tag=commentVC.index
                    println("index:\(tag)")
                    if let tag=tag{
                    //update comment"
                    self.tableView.beginUpdates()
                    self.tableView.reloadSections(NSIndexSet(index:tag),withRowAnimation: UITableViewRowAnimation.Automatic)
                    self.tableView.endUpdates()
                    }

                }
                
                
            }
            
        }
    }


}

// MARK: tableview delegate and datasource
extension HomeViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //loadmore if (indexPath.section == (currentRange.endIndex - 1) && !loadedAllContent)
       // println("willDisplayCell: \(indexPath.section) \(timelineComponent.content[indexPath.section].totalVotes)")
     
        timelineComponent.calledCellForRowAtIndexPath(indexPath)
        
    }

}
extension HomeViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("PostHeader") as! HomePostSectionHeaderView
        var post:Post?
        post=self.timelineComponent.content[section]
        
        headerCell.post=post
        headerCell.questionLabel.lineBreakMode = .ByWordWrapping
        headerCell.questionLabel.numberOfLines=0
        headerCell.questionLabel.sizeToFit()
    
       // println("height 1 \(headerCell.questionLabel.frame.height)")
        //let the header show up when updated
        return headerCell.contentView
    }
    
    
   
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var post:Post?
        post=self.timelineComponent.content[section]
        
          var length:Int=0
        if let title = post?.title{
            
           //TODO: fix resize the header size
           length=count(title)
       }
        
        var height=CGFloat((length/20)*10)+HEADER_CELL_HEIGHT
        
        return height
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var num=0
        num=timelineComponent.content.count ?? 0
        return num
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell=tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! HomePostTableViewCell
        
        var post:Post?
        
        post=timelineComponent.content[indexPath.section]
        
       // println("cellforRowat index.section: \(indexPath.section) post.totalValue: \(post.totalVotes) ")
        
        // download, only downloaded with needed
        if let post=post {
        post.downloadImage()
        //get post statistic
        post.getPostStatistic()
            cell.post=post
            
            // vote button, animation
            
            if(post.voteUpdate){
                cell.voteFavoriteButton.select()
                timelineComponent.content[indexPath.section].voteUpdate=false
            }
            

        }
        
 
        
        //setting img radious
       DesignHelper.setImageCornerRadius(cell.img1)
       DesignHelper.setImageCornerRadius(cell.img2)
        
        
        
       // establish gestureRecognizer
        cell.img1.userInteractionEnabled=true
        cell.img1.tag=indexPath.section
        
        cell.img2.userInteractionEnabled=true
        cell.img2.tag=indexPath.section
        
        var img1tapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("img1Tapped:" ))
        cell.img1.addGestureRecognizer(img1tapped)
        
        var img2tapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("img2Tapped:" ))
        cell.img2.addGestureRecognizer(img2tapped)
        
        
        // commentButton:
        cell.commentButton.tag=indexPath.section
        
        cell.commentButton.addTarget(self, action: Selector("commentButtonTapped:" ), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.commentNum.text="" //initialize the comment number
        
        
        //check if this sell is voted by this user, if voted, show the results
    
        var postId=post?.objectId
        
        if let postId=postId{
            ParseHelper.isUserVotedForPost(postId){ (results: [AnyObject]?, error: NSError?) -> Void in
                
                if let count=results?.count{
                    if count != 0{
                       
                        // if is voted show the results
                        cell.vote1.alpha=1;
                        cell.vote2.alpha=1;
                    }else{
                        cell.vote1.alpha=0;
                        cell.vote2.alpha=0;
                    }
                }
                
            }
            
            
            
            // get comment number
            ParseHelper.getCommentNumberWithPostId(postId){ (results: [AnyObject]?, error:NSError?) -> Void in
                if let results=results{
                    cell.commentNum.text=(results.count == 0) ? "": String(results.count)
                    
                    
                }
                
            }


        }
        
       
        return cell
    }
    
    
    func commentButtonTapped(sender:UIButton!){
        
       // println("button tag \(sender.tag)")
        
        var postId:String?
        var post:Post?
        var tag=sender.tag
        postId=timelineComponent.content[tag].objectId
        post=timelineComponent.content[tag]
        
        self.selectedCommentIndex=tag
        
        if let postId=postId{
            self.performSegueWithIdentifier("commentPushSegue", sender: post)
        }
        
    }
    
    func img1Tapped(recognizer:UITapGestureRecognizer ){
        
        println("the \(recognizer.view?.tag)th  posts: img1 tapped")
        
        if let tag=recognizer.view?.tag{
            var postId:String?
            var poster:PFUser?
            
            postId=timelineComponent.content[tag].objectId
            poster=timelineComponent.content[tag].poster
            
            if let postId=postId{
                println("postId:\(postId)")
            
            ParseHelper.isUserVotedForPost(postId){ (results:[AnyObject]?, error:NSError?) -> Void in
                if let results=results as? [PFObject]{
                    
                    if(results.count != 0){
                    println("voted!")
                    // alreday voted!
                    // show results:
                    }else{
                    println("save new vote")
                    // save the result, and show results
                    ParseHelper.saveVote(postId, choice: 1)
                        
                    //update this post statistics
                        ParseHelper.updatePostStatistic(postId, choice: 1){ (success:Bool,error:NSError?) -> Void in
                            
                            if success {
                                println("success upadatePostStatistic")
                                //update post statistic
                                
                                //update the content
                                ParseHelper.findPostWithPostId(postId){ (results:[AnyObject]?, error:NSError?) -> Void in
                                    
                                    if let results=results as? [Post]{
                                        
                                        self.timelineComponent.content[tag]=results.first!
                                        println("totalVote\(self.timelineComponent.content[tag].totalVotes)")                                       //send notification if the voter is not poster
                                        if let poster=poster{
                                            if (poster.objectId != PFUser.currentUser()?.objectId){
                                                
                                                if let post=results.first{
                                                    ParseHelper.uploadNotification(PFUser.currentUser()!, toUser: post.poster!, messageType: "vote", post: post)
                                                }

                                                
                                                PushNotificationHelper.sendVoteNotification(poster)
                                            }
                                            
                                        }
 
                                       self.tableView.beginUpdates()
                                        self.timelineComponent.content[tag].voteUpdate=true
                                        self.tableView.reloadSections(NSIndexSet(index:tag),withRowAnimation: UITableViewRowAnimation.Automatic)
                                      self.tableView.endUpdates()

                                    }
                                    
                                }
                            }
                            
                        }
                        
            
                        
                }
               }
              
                if error != nil {
                    println(error)
                }
                
            }
          }
        }
    
    }
    
    
    func img2Tapped(recognizer:UITapGestureRecognizer ){
        
        println("the \(recognizer.view?.tag)th  posts: img2 tapped")
        
        if let tag=recognizer.view?.tag{
            var postId:String?
            var poster:PFUser?
            postId=timelineComponent.content[tag].objectId
            poster=timelineComponent.content[tag].poster
            
            if let postId=postId{
                println("postId:\(postId)")
                
                ParseHelper.isUserVotedForPost(postId){ (results:[AnyObject]?, error:NSError?) -> Void in
                    if let results=results as? [PFObject]{
                        
                        if(results.count != 0){
                            println("voted!")
                            // alreday voted!
                            // show results:
                        }else{
                            println("save new vote")
                            // save the result, and show results
                            ParseHelper.saveVote(postId, choice: 2)
                            
                            //update this post statistics
                            ParseHelper.updatePostStatistic(postId, choice:2){ (success:Bool,error:NSError?) -> Void in
                                
                                if success {
                                    println("success upadatePostStatistic")
                                    //update post statistic
                                    
                                    //update the content
                                    ParseHelper.findPostWithPostId(postId){ (results:[AnyObject]?, error:NSError?) -> Void in
                                        
                                        if let results=results as? [Post]{
                                            self.timelineComponent.content[tag]=results.first!
                                            println("totalVote\(self.timelineComponent.content[tag].totalVotes)")
                                            //send notification if the voter is not poster
                                    if let poster=poster{
                                        if (poster.objectId != PFUser.currentUser()?.objectId){
                                            
                                            if let post=results.first{
                                                ParseHelper.uploadNotification(PFUser.currentUser()!, toUser: post.poster!, messageType: "vote", post: post)
                                            }
                                            
                                                PushNotificationHelper.sendVoteNotification(poster)
                                            }
                                                
                                        }

                                            
                                            self.tableView.beginUpdates()
                                            self.timelineComponent.content[tag].voteUpdate=true
                                            self.tableView.reloadSections(NSIndexSet(index:tag),withRowAnimation: UITableViewRowAnimation.Automatic)
                                            self.tableView.endUpdates()
                                            
                                        }
                                        
                                    }
                                }
                                
                            }
     
                        }
                    }
                    
                    if error != nil {
                        println(error)
                    }
                    
                }
            }
        }
        
    }
    

    



}

