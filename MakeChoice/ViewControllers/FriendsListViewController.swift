//
//  FriendsListViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/13/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit
import MBProgressHUD

class FriendsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var postNum: UILabel!
    
   
    var friends:[PFUser]=[]{
        didSet{
       self.tableView.reloadData()
        }
    }
    
    //TODO: using hashtable to check unique
    // to avoid that friends accept each other at the same time, and server didn't not save both of them
    func getFriendsDictionary(friends:[PFUser]) -> NSDictionary {
        var friendsDictionary:[String:PFUser]=[:]
        for friend in friends{
           
            if(friendsDictionary[friend.objectId!]==nil){
               
                 friendsDictionary[friend.objectId!]=friend
            }else{
                // find duplicate, remove one pair;
                //update friendnum 
                println("deal with duplicate")
                 println("friend: \(friend.objectId), \(friend.username)")
                NSNotificationCenter.defaultCenter().postNotificationName("DealWithFriendsDuplicate", object: self)
                
                if let user=PFUser.currentUser(){
                    ParseHelper.removeFriend(user, toUser: friend)
                    ParseHelper.removeFriend(friend, toUser: user)
                }
  
               
            }
           
        }
        
        return  friendsDictionary
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.dataSource=self
        self.tableView.delegate=self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
   
        UICustomSettingHelper.MBProgressHUDLoading(self.view)
        
        ParseHelper.allFriends{ (results:[AnyObject]?, error: NSError?) -> Void in
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            if error != nil{
                UICustomSettingHelper.sweetAlertNetworkError()
            }
            
            if let results = results as? [PFObject]{
                if results.count>0 {
                    
                var friendsArray=results.map{$0[PF_FRIEND_FRIEND] as! PFUser}
                self.friends=self.getFriendsDictionary(friendsArray).allValues as! [PFUser]
                    
                self.tableView.reloadData()
                }else{
                    // if no friend
                    self.friends=[]
                    self.tableView.reloadData()
                }
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

//MARK: dataSouce and delegate

extension FriendsListViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.friends.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
  
        
        let cell=tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as! FriendsTableViewCell
        
        cell.friend=self.friends[indexPath.row]
        
        return cell
    }

}

extension FriendsListViewController:UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       var user=friends[indexPath.row]
        self.performSegueWithIdentifier("friendPostSegue", sender: user)
       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier=="friendPostSegue") {
           
            let friendPostVC = segue.destinationViewController as! CategoryDetailViewController
            friendPostVC.user=sender as? PFUser
            friendPostVC.option=2
            
        }
    }

    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == .Delete) {
          
            
            SweetAlert().showAlert("Are you sure?", subTitle: "Your friend will be permanently deleted!", style: AlertStyle.Warning, buttonTitle:"Cancel", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes, delete it!", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
                if isOtherButton == true {
                    
                    print("Cancel Button  Pressed", appendNewline: false)
                    tableView.editing=false;
                }
                else {
                    
                    let friend=self.friends[indexPath.row]
                    
                    UICustomSettingHelper.MBProgressHUDSimple(self.view)
                    ParseHelper.removeFriend(friend){
                        (results:[AnyObject]?, error: NSError?) -> Void in
                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                        if error != nil{
                            UICustomSettingHelper.sweetAlertNetworkError()
                        }
                        if let results=results as? [PFObject]{
                            // update the statistic in profile view controller
                            //broadcasting, since one friend relation has two objects
                            
                            var flag=0;
                            for result in results{
                                //should print error
                                result.deleteInBackgroundWithBlock{ (success: Bool, error: NSError?) -> Void in
                                    
                                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                    if error != nil{
                                        println("error: \(error)")
                                       UICustomSettingHelper.sweetAlertNetworkError()
                                    }
                                    
                                    // a pair of friends has two friendrelation object
                                    if (success && flag==0){
                                        flag=1
                                        
                                        var ind=ParseHelper.parseGetObjectIndexFromArray(self.friends, object: friend)
                                       
                                        
                                        if(ind != -1){
                                            if(ind>=0 && ind<=self.friends.count-1){
                                                
                                                 self.friends.removeAtIndex(ind)
                                             NSNotificationCenter.defaultCenter().postNotificationName("DeleteFriend", object: nil)
                                                 SweetAlert().showAlert("Deleted!", subTitle: "Friend has been deleted!", style: AlertStyle.Success)
                                            }
                                           
                                            println("friends:count \(self.friends.count)")
                                        }
                                        
                                              
                                    }
                                }
                            }
                        }
                     }
                    
                    
                    
                   
                }
            }

        }
        
    }

}
