//
//  FriendRequestViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/16/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit

class FriendRequestViewController: UIViewController {
    
    var friendRequests:[PFObject]=[]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
     self.tableView.dataSource=self
     self.tableView.delegate=self
        
        
    }

    override func viewWillAppear(animated: Bool) {
        ParseHelper.getFriendsRequest{(results:[AnyObject]?, error: NSError?) -> Void in
            
            if let results=results{
                
                self.friendRequests=results as! [PFObject]
                
                self.tableView.reloadData()
                
            }
            
            if (error != nil) {
                println("error friend requests \(error)")
            }
 
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

}

// MARK: dataSouce

extension FriendRequestViewController: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        println("num of request\(friendRequests.count)")
        return friendRequests.count
       
    }
    
 
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell=tableView.dequeueReusableCellWithIdentifier("friendRequestCell", forIndexPath: indexPath) as! FriendRequestTableViewCell
        
        var request=friendRequests[indexPath.row]
        var user=request[PF_FRIENDSREQUEST_FROMUSER] as! PFUser
       
        cell.user=user
        cell.message.text=request[PF_FRIENDSREQUEST_MESSAGE] as? String ?? ""
        
        
        return cell
        
    }

}

extension FriendRequestViewController:UITableViewDelegate{
    
}
