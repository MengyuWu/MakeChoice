//
//  YourPostsViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/12/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit
import ConvenienceKit
import Social

class YourPostsViewController: UIViewController,TimelineComponentTarget {
    
    @IBOutlet weak var tableView: UITableView!
    
    var timelineComponent:TimelineComponent<Post, YourPostsViewController>!
    
    let defaultRange = 0...4
    let additionalRangeSize = 5
    
    var postId:String?=""
    var selectedPost:Post?
  
    /**
    This method should load the items within the specified range and call the
    `completionBlock`, with the items as argument, upon completion.
    */
    func loadInRange(range: Range<Int>, completionBlock: ([Post]?) -> Void){
        ParseHelper.timelineRequestforCurrentUserOwn(range){ (result: [AnyObject]?, error: NSError?) -> Void in
            let posts = result as? [Post] ?? []
            completionBlock(posts)
            
        }
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.dataSource=self
        self.tableView.delegate=self
        timelineComponent = TimelineComponent(target: self)
//        
//        tableView.estimatedRowHeight=100
//        tableView.rowHeight=UITableViewAutomaticDimension
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        timelineComponent.refresh(self)
        tableView.reloadData()
        
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
       
        if(segue.identifier=="postToDetailSegue") {
            let postDetailViewController = segue.destinationViewController as! PostDetailViewController
            postDetailViewController.post=self.selectedPost
 
        }else if(segue.identifier=="addressBookSegue") {
            let addressBookViewController = segue.destinationViewController as! AddressBookViewController
            addressBookViewController.post=sender as? Post
            
        }

    }


}

// MARK: dataSouce
extension YourPostsViewController: UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
      return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return timelineComponent.content.count ?? 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCellWithIdentifier("YourPostsCell", forIndexPath: indexPath) as! YourPostsTableViewCell
        
        let post=timelineComponent.content[indexPath.section]
        
        
        // download, only downloaded with needed
        post.downloadImage()
        //get post statistic
        post.getPostStatistic()
        cell.post=post
        cell.title.text=post.title ?? ""
        cell.title.sizeToFit()
        //cell.title.lineBreakMode = .ByWordWrapping
        
        //setting img radious
        DesignHelper.setImageCornerRadius(cell.img1)
        DesignHelper.setImageCornerRadius(cell.img2)
        //set segue delegate
        cell.delegate=self
        
        return cell
        
    }

}

// MARK: delegate
extension YourPostsViewController:UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("did selectrow")
        self.selectedPost=timelineComponent.content[indexPath.section]
        self.performSegueWithIdentifier("postToDetailSegue", sender: self)     //2
        
    }

    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        timelineComponent.calledCellForRowAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
       return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == .Delete) {
            
            print("swipe delete")
            
            
            SweetAlert().showAlert("Are you sure?", subTitle: "You post will permanently delete!", style: AlertStyle.Warning, buttonTitle:"Cancel", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes, delete it!", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
                if isOtherButton == true {
                    
                    print("Cancel Button  Pressed", appendNewline: false)
                    tableView.editing=false;
                }
                else {
                    let post=self.timelineComponent.content[indexPath.section]
                    let postId=post.objectId ?? ""
                    
                    
                    ParseHelper.deletePostWithPostId(postId){ (success:Bool, error: NSError?) -> Void in
                        if success {
                            println("delete postID: \(postId)")
                            
                            // refresh
                            self.timelineComponent.refresh(self)
                            NSNotificationCenter.defaultCenter().postNotificationName("DeletePost", object: nil)
                            
                            SweetAlert().showAlert("Deleted!", subTitle: "Your post has been deleted!", style: AlertStyle.Success)
                        }

                    
                }
            }

            
            
            
            }


        }
        
    }


}

// MARK:  YourPostsTableViewCellSegueDelegate
extension YourPostsViewController:YourPostsTableViewCellDelegate{
    
    func cell(cell: YourPostsTableViewCell, didSelectAddressBookSegue post: Post){
        println("address book")
        self.performSegueWithIdentifier("addressBookSegue", sender: post)
    }
    
    func cell(cell: YourPostsTableViewCell, didSelectShareToFacebook post: Post){
    println("share to facebook")
        
    var shareToFacebook=SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        
        var questions=post.title ?? ""
        //Add attachment as NSData,
        post.downloadImageSynchronous()
        var image1=post.image1.value
        var image2=post.image2.value
        var finalImage:UIImage?
        var finalImageData:NSData?
        if let image1=image1, image2=image2 {
            println("merge images")
            finalImage=DesignHelper.mergeTwoImages(image1, image2: image2)
            finalImageData=UIImagePNGRepresentation(finalImage)
            
        }
     shareToFacebook.addImage(finalImage)
     shareToFacebook.setInitialText("Hey, help me vote on: \(questions), Download MakeChoice: URL")
        
        self.presentViewController(shareToFacebook,animated:true, completion:nil)
    
    
        
    }
    
    func presentViewController(alertController: UIAlertController) {
           self.presentViewController(alertController, animated: true, completion: nil)
    }
}