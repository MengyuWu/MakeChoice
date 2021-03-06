//
//  HomeViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/9/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit
import ConvenienceKit
import MBProgressHUD

struct IntroConstants {
  
    static let HasShownTutorial = "Has Shown Tutorial"
    static let HasShownTermofServices = "Has Shown Term of Service"
}

class HomeViewController: UIViewController,TimelineComponentTarget {
    var hasShownTutorial: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(IntroConstants.HasShownTutorial) ?? false
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: IntroConstants.HasShownTutorial)
        }
    }
    
    var hasShownTermofServices: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(IntroConstants.HasShownTermofServices) ?? false
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: IntroConstants.HasShownTermofServices)
        }
    }
  
    @IBOutlet weak var tableView: UITableView!
    
    // implement timelineComponentTarget
    // angled brackets: the type of object you are displaying (Post) and the class that will be the target of the TimelineComponent (that's the TimelineViewController in our case).
    var timelineComponent:TimelineComponent<Post, HomeViewController>!
   
    let defaultRange = 0...4
    let additionalRangeSize = 5
    
    var friendPosts:[Post]=[]
    
    var isFriendPost=false
    
    var selectedCommentIndex:Int?
    
    var selectedReportType:String=""
    
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
    
   
    @IBAction func scrollToTopPressed(sender: AnyObject) {
        
        //test, scroll to top
        //self.tableView.setContentOffset(CGPointZero, animated: true)
        //refresh
        timelineComponent.refresh(self)
    }
    
  
    
    
    /**
    This method should load the items within the specified range and call the
    `completionBlock`, with the items as argument, upon completion.
    */
    func loadInRange(range: Range<Int>, completionBlock: ([Post]?) -> Void){
        UICustomSettingHelper.MBProgressHUDLoading(self.view)
        if(isFriendPost){
            ParseHelper.timelineRequestforCurrentUserWithOptions(range,isFriendPost:true, category:0){ (result: [AnyObject]?, error: NSError?) -> Void in
                let posts = result as? [Post] ?? []
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                completionBlock(posts)
                
                if error != nil{
                    UICustomSettingHelper.sweetAlertNetworkError()
                }
                
            }
        }else{
            
            ParseHelper.timelineRequestforCurrentUserWithOptions(range,isFriendPost:false, category:0){ (result: [AnyObject]?, error: NSError?) -> Void in
                let posts = result as? [Post] ?? []
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                completionBlock(posts)
                
                if error != nil{
                   UICustomSettingHelper.sweetAlertNetworkError()
                }
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
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "userPostReceived", name: "UserPost", object: nil)
      
    }
    
    func userPostReceived(){
        println("home userPostReceived")
        timelineComponent.refresh(self)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !self.hasShownTermofServices {
            termsOfService()
            self.hasShownTermofServices = true
        }else{
            if !self.hasShownTutorial{
             showTipsAlert()
             
            }
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
       
    }

    func termsOfService()
    {
        // SwiftSpinner.show("Loading...", animated: true)
        let vc = AgreeCSSViewController()
        vc.filename = "TermsOfService"
        vc.title = "Terms of Service"
        let navVC = UINavigationController(rootViewController: vc)
        self.presentViewController(navVC, animated: true) {
            //  SwiftSpinner.hide()
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    
    }
    
    func showTipsAlert(){
        SweetAlert().showAlert("Tips", subTitle: "1.Tap on your choice, you will see the results after voting! \n 2.Pull to refresh!", style: AlertStyle.Warning, buttonTitle:"Ok", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "Don't show again!", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                
                print("ok Button  Pressed", appendNewline: false)
            }
            else {
              self.hasShownTutorial = true
               print("Don't show again Button  Pressed", appendNewline: false)
            }
        }

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


  
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
            

        }else if(segue.identifier=="ReportSegue"){
            let reportVC=segue.destinationViewController as! ReportViewController
            if let post=sender as? Post{
                reportVC.post=post
                reportVC.type=self.selectedReportType
            }
            
        }
        
        
    }
    
    
    // MARK:unwind segue
    @IBAction func unwindToSegue(segue: UIStoryboardSegue){
        if let identifier = segue.identifier {
            if (identifier=="commentUnwind") {
               
                if(segue.sourceViewController .isKindOfClass(CommentViewController)){
                    var commentVC=segue.sourceViewController as! CommentViewController
                    var tag=commentVC.index
                  
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
          timelineComponent.calledCellForRowAtIndexPath(indexPath)
        
    }

}
extension HomeViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let screenWidth = UIScreen.mainScreen().bounds.width
        let imageHeight=screenWidth/2/3*4
        let cellHeight=imageHeight+60
        
        return cellHeight
        
    }

    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("PostHeader") as! HomePostSectionHeaderView
        var post:Post?
        post=self.timelineComponent.content[section]
        
        headerCell.post=post
        headerCell.questionLabel.lineBreakMode = .ByWordWrapping
        headerCell.questionLabel.numberOfLines=0
        headerCell.questionLabel.sizeToFit()
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
        var height=CGFloat((length/15)*10)+HEADER_CELL_HEIGHT
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
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell=tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! HomePostTableViewCell
        
        var post:Post?
        
        post=timelineComponent.content[indexPath.section]
        
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
        
        
        //reportButton:
        cell.reportButton.tag=indexPath.section
        cell.reportButton.addTarget(self, action:Selector("reportButtonTapped:" ), forControlEvents: UIControlEvents.TouchUpInside)
        
        //check if this sell is voted by this user, if voted, show the results
    
        var postId=post?.objectId
        if let postId=postId{
            
          
          ParseHelper.isUserVotedForPost(postId){ (results: [AnyObject]?, error: NSError?) -> Void in
            
            if error != nil{
                UICustomSettingHelper.sweetAlertNetworkError()
            }

                if let count=results?.count{
                    if count != 0{
                        
                       UICustomSettingHelper.showVoteBars(cell, view: self.view)
     
                    }else{
                        cell.vote1Bar.alpha=0
                        cell.vote2Bar.alpha=0
                        
                        
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
    
    
    func reportButtonTapped(sender:UIButton!){
        var postId:String?
        var post:Post?
        var tag=sender.tag
        postId=timelineComponent.content[tag].objectId
        post=timelineComponent.content[tag]
        
        if let postId=postId{
            
            //check this post is deleted or not
            UICustomSettingHelper.MBProgressHUDSimple(self.view)
            ParseHelper.findPostWithPostId(postId){(results:[AnyObject]?, error:NSError?) in
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                if error != nil{
                    UICustomSettingHelper.sweetAlertNetworkError()
                }
                
                
                if let results=results{
                    if results.count==0{
                        SweetAlert().showAlert("Does not exist!", subTitle: "This post has been deleted!", style: AlertStyle.Warning)
                        self.timelineComponent.refresh(self)
                    }else{
                        
                        let alertController = UIAlertController(title: nil, message: "Report", preferredStyle: .ActionSheet)
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        
                        
                        let reportPostAction = UIAlertAction(title: "Report content", style: .Default){ (action) in
                            self.selectedReportType="content"
                            self.performSegueWithIdentifier("ReportSegue", sender: post)
                        }
                        alertController.addAction(reportPostAction)
                        
                        
                        let reportUserAction=UIAlertAction(title: "Report user", style: .Default){ (action) in
                            self.selectedReportType="user"
                            self.performSegueWithIdentifier("ReportSegue", sender: post)
                        }
                        alertController.addAction(reportUserAction)
                        
                       self.presentViewController(alertController, animated: true, completion: nil)

                    }
                    
                }
            }
        }

    }
    
    
    func commentButtonTapped(sender:UIButton!){
        var postId:String?
        var post:Post?
        var tag=sender.tag
        postId=timelineComponent.content[tag].objectId
        post=timelineComponent.content[tag]
        
        self.selectedCommentIndex=tag
        
        if let postId=postId{
            
            //check this post is deleted or not
            UICustomSettingHelper.MBProgressHUDSimple(self.view)
            ParseHelper.findPostWithPostId(postId){(results:[AnyObject]?, error:NSError?) in
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                if error != nil{
                    UICustomSettingHelper.sweetAlertNetworkError()
                }

                
                if let results=results{
                    if results.count==0{
                        SweetAlert().showAlert("Does not exist!", subTitle: "This post has been deleted!", style: AlertStyle.Warning)
                        self.timelineComponent.refresh(self)
                    }else{
                         self.performSegueWithIdentifier("commentPushSegue", sender: post)
                    }
                
                }
              }
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
                
                UICustomSettingHelper.MBProgressHUDSimple(self.view)
                ParseHelper.findPostWithPostId(postId){ (results:[AnyObject]?, error:NSError?) in
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    if error != nil{
                        UICustomSettingHelper.sweetAlertNetworkError()
                    }

                    if let results=results{
                        if results.count==0{
                             SweetAlert().showAlert("Does not exist!", subTitle: "This post has been deleted!", style: AlertStyle.Warning)
                            self.timelineComponent.refresh(self)
                            
                        }else{
                            ParseHelper.isUserVotedForPost(postId){ (results:[AnyObject]?, error:NSError?) -> Void in
                                if let results=results as? [PFObject]{
                                    
                                    if(results.count != 0){
                                        
                                         SweetAlert().showAlert("You have already voted!", subTitle: "", style: AlertStyle.Warning)
                                        
                                    }else{
                                       
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
                                                         self.timelineComponent.content[tag].votedJustNow=true
                                                        self.tableView.reloadSections(NSIndexSet(index:tag),withRowAnimation: UITableViewRowAnimation.Automatic)
                                                        self.tableView.endUpdates()
                                                        
                                                    }
                                                    
                                                }
                                            }
                                            
                                        }
                                        
                                        
                                        
                                    }
                                }
                                
                                if error != nil {
                                    if error != nil{
                                       UICustomSettingHelper.sweetAlertNetworkError()
                                    }

                            
                                }
                                
                            }
                        }
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
                
                UICustomSettingHelper.MBProgressHUDSimple(self.view)
                ParseHelper.findPostWithPostId(postId){(results:[AnyObject]?, error:NSError?) in
                    
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    if error != nil{
                       UICustomSettingHelper.sweetAlertNetworkError()
                    }
                
                    if let results=results{
                        if results.count==0{
                            SweetAlert().showAlert("Does not exist", subTitle: "This poll has been deleted!", style: AlertStyle.Warning)
                            self.timelineComponent.refresh(self)
                            
                        }else{
                            ParseHelper.isUserVotedForPost(postId){ (results:[AnyObject]?, error:NSError?) -> Void in
                                if let results=results as? [PFObject]{
                                    
                                    if(results.count != 0){
                                       
                                         SweetAlert().showAlert("You have already voted!", subTitle: "", style: AlertStyle.Warning)
                                
                                    }else{
                                  
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
                                                        self.timelineComponent.content[tag].votedJustNow=true
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
        }
        
    }
    
    



}

