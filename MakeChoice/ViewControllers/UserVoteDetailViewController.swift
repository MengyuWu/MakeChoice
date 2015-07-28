//
//  UserVoteDetailViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/13/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit
import ConvenienceKit
import MBProgressHUD

class UserVoteDetailViewController: UIViewController,TimelineComponentTarget{

    @IBOutlet weak var tableView: UITableView!
    
    var postId:String=""
    
   // var votes:[PFObject] = []
    
    var timelineComponent:TimelineComponent<PFObject, UserVoteDetailViewController>!
    
    let defaultRange = 0...4
    let additionalRangeSize = 5
    
    func loadInRange(range: Range<Int>, completionBlock: ([PFObject]?) -> Void){
        UICustomSettingHelper.MBProgressHUDLoading(self.view)
        ParseHelper.timelineRequestfindVotesWithPostId(range, postId: self.postId){ (result: [AnyObject]?, error: NSError?) -> Void in
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            if error != nil{
                SweetAlert().showAlert("Error!", subTitle: "Network Error", style: AlertStyle.Error)
            }

            
            let votes = result as? [PFObject] ?? []
            completionBlock(votes)
        }
        
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
      tableView.delegate=self
      tableView.dataSource=self
      timelineComponent = TimelineComponent(target: self)
        
    }
 
    
    
    
    //TODO: need to have some better way to cache something unchanged
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

// MARK: delegate and dataSource

extension UserVoteDetailViewController: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //println("number of rows: \(votes.count)")
       return 1
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return timelineComponent.content.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
         let cell=tableView.dequeueReusableCellWithIdentifier("userVoteCell", forIndexPath: indexPath) as! UserVoteDetailTableViewCell
     
       cell.vote = timelineComponent.content[indexPath.section]
        
        var postId: AnyObject?=cell.vote![PF_VOTE_POSTID]
        
        println("index: \(indexPath.section)  \(postId)")
        
       return cell
        
    }
}

extension UserVoteDetailViewController: UITableViewDelegate{
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // load more cell
        timelineComponent.calledCellForRowAtIndexPath(indexPath)
    }
}