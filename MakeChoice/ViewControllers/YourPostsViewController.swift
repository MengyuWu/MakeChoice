//
//  YourPostsViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/12/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit
import ConvenienceKit

class YourPostsViewController: UIViewController,TimelineComponentTarget {
    
    @IBOutlet weak var tableView: UITableView!
    
    var timelineComponent:TimelineComponent<Post, YourPostsViewController>!
    
    let defaultRange = 0...4
    let additionalRangeSize = 5
  
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
        tableView.dataSource=self
        tableView.delegate=self
        timelineComponent = TimelineComponent(target: self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        timelineComponent.refresh(self)
        
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
        post.downloadImage()
        
        // download, only downloaded with needed
        post.downloadImage()
        //get post statistic
        post.getPostStatistic()
        cell.post=post
        cell.title.text=post.title ?? ""
        //setting img radious
        DesignHelper.setImageCornerRadius(cell.img1)
        DesignHelper.setImageCornerRadius(cell.img2)
        
        return cell
        
    }

}

// MARK: delegate
extension YourPostsViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        timelineComponent.calledCellForRowAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
       return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == .Delete) {
            
            print("swipe delete")
            
            let post=timelineComponent.content[indexPath.section]
            let postId=post.objectId ?? ""
            
            
            ParseHelper.deletePostWithPostId(postId){ (success:Bool, error: NSError?) -> Void in
                if success {
                    println("delete postID: \(postId)")
                    // refresh
                    self.timelineComponent.refresh(self)
                }
                
            }


        }
        
    }


}