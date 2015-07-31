//
//  FriendRequestViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/16/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit
import MBProgressHUD

class FriendRequestViewController: UIViewController {
    
    var friendRequests:[PFObject]=[]{
        didSet{
            self.tableView.reloadData()
        }
    }

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
     self.tableView.dataSource=self
     self.tableView.delegate=self
     
        self.tableView.estimatedRowHeight=80
        self.tableView.rowHeight=UITableViewAutomaticDimension
        
    }

    override func viewWillAppear(animated: Bool) {
        UICustomSettingHelper.MBProgressHUDSimple(self.view)
        ParseHelper.getFriendsRequest{(results:[AnyObject]?, error: NSError?) -> Void in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            if error != nil{
                UICustomSettingHelper.sweetAlertNetworkError()
            }

            if let results=results{
                self.friendRequests=results as! [PFObject]
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
        
        return friendRequests.count
       
    }
    
 
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell=tableView.dequeueReusableCellWithIdentifier("friendRequestCell", forIndexPath: indexPath) as! FriendRequestTableViewCell
        
        var request=friendRequests[indexPath.row]
        var user=request[PF_FRIENDSREQUEST_FROMUSER] as! PFUser
       
        cell.user=user
        cell.message.text=request[PF_FRIENDSREQUEST_MESSAGE] as? String ?? ""
        cell.time.text=request.createdAt?.shortTimeAgoSinceDate(NSDate()) ?? ""
        cell.delegate=self

        return cell
        
    }

}

extension FriendRequestViewController:UITableViewDelegate{
    
    
}

extension FriendRequestViewController:FriendRequestTableViewCellDelegate{
    func cell(cell:FriendRequestTableViewCell, didSelectAcceptFriend user: PFUser){
        
        println("accept")
        
        //add friend relationship, check whether they are friend, if they are friend doesn't need to add again
        
        ParseHelper.hasFriendRelation(PFUser.currentUser()!, user2: user){
            (results:[AnyObject]?, error: NSError?) -> Void in
            
            if let results=results{
                if results.count>0 {
                    println("already added!")
                   SweetAlert().showAlert("Added", subTitle: "Friend is already added!", style: AlertStyle.Warning)
                }else{
                    ParseHelper.addFriendFromUserToUser(PFUser.currentUser()!, toUser:user)
                    ParseHelper.addFriendFromUserToUser(user, toUser:PFUser.currentUser()!)
                }
            }
            
        }
        
      
        
        // remove all the request from selected user, from parse
        ParseHelper.removeFriendRequestFromUser(user){ (results: [AnyObject]?, error: NSError?) -> Void in
            if let results=results as? [PFObject]{
                for result in results{
                    result.deleteInBackgroundWithBlock{ (success:Bool, error: NSError?) -> Void in
                        if error != nil{
                            println("delete request error\(error)")
                        }else{
                            //refresh requst list
                            println("refresh")
                            UICustomSettingHelper.MBProgressHUDSimple(self.view)
                            ParseHelper.getFriendsRequest{(results:[AnyObject]?, error: NSError?) -> Void in
                                
                                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                if let results=results{
                                    self.friendRequests=results as! [PFObject]
                                }
                                if (error != nil) {
                                    UICustomSettingHelper.sweetAlertNetworkError()
                                    println("error friend requests \(error)")
                                }
                            }

                        }
                        
                    }
                }
                
            }
            
        }
  
        
        //push accept notification
    PushNotificationHelper.sendFriendRequesResponseNotification(user, choice: 1)
      

    }
    
    
    func cell(cell:FriendRequestTableViewCell, didSelectRejectFriend user: PFUser){
        println("reject")
        
        // remove all the request from selected user, from parse
        ParseHelper.removeFriendRequestFromUser(user){ (results: [AnyObject]?, error: NSError?) -> Void in
            if let results=results as? [PFObject]{
                for result in results{
                    result.deleteInBackgroundWithBlock{ (success:Bool, error: NSError?) -> Void in
                        if error != nil{
                             UICustomSettingHelper.sweetAlertNetworkError()
                            println("delete request error\(error)")
                        }else{
                            //refresh requst list
                            //refresh requst list
                            println("refresh")
                            UICustomSettingHelper.MBProgressHUDSimple(self.view)
                            ParseHelper.getFriendsRequest{(results:[AnyObject]?, error: NSError?) -> Void in
                                
                                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                
                                if let results=results{
                                    self.friendRequests=results as! [PFObject]
                                }
                                if (error != nil) {
                                    UICustomSettingHelper.sweetAlertNetworkError()
                                    println("error friend requests \(error)")
                                }
                            }

                        }
                        
                    }
                }
                
            }
 
        }
        
        //push accept notification
       
        PushNotificationHelper.sendFriendRequesResponseNotification(user, choice: 2)
       

    }
    
}
