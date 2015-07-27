//
//  FriendsListViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/13/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit

class FriendsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var postNum: UILabel!
    var friends:[PFUser]=[]{
        didSet{
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.dataSource=self
        self.tableView.delegate=self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //println("friends list view will appear")
        ParseHelper.allFriends{ (results:[AnyObject]?, error: NSError?) -> Void in
            if let results = results as? [PFObject]{
                if results.count>0 {
                self.friends=results.map{$0[PF_FRIEND_FRIEND] as! PFUser}
                //println("friends in view will apper: \(self.friends.count)")
                }else{
                    // if no friend
                    self.friends=[]
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
        
      //  println("friends: \(self.friends.count)")
        
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
            
            print("swipe delete")
            
            SweetAlert().showAlert("Are you sure?", subTitle: "You file will permanently delete!", style: AlertStyle.Warning, buttonTitle:"Cancel", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes, delete it!", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
                if isOtherButton == true {
                    
                    print("Cancel Button  Pressed", appendNewline: false)
                    tableView.editing=false;
                }
                else {
                    
                    let friend=self.friends[indexPath.row]
                    
                    ParseHelper.removeFriend(friend){
                        (results:[AnyObject]?, error: NSError?) -> Void in
                        
                        if let results=results as? [PFObject]{
                            // update the statistic in profile view controller
                            //broadcasting, since one friend relation has two objects
                            // NSNotificationCenter.defaultCenter().postNotificationName("DeleteFriend", object: nil)
                            
                            var index=0;
                            for result in results{
                                //should print error
                                result.deleteInBackgroundWithBlock{ (success: Bool, error: NSError?) -> Void in
                                    
                                    if (success && index==0){
                                        index++
                                        // update the statistic in profile view controller
                                        //broadcasting, could use this, if listneing object call parse.getnumof friend
                                        NSNotificationCenter.defaultCenter().postNotificationName("DeleteFriend", object: nil)
                                    }
                                    
                                    if error != nil{
                                        println("remove friend error1\(error)")
                                    }
                                }
                            }
                        }
                        
                        if error != nil {
                            println("remove friend error2\(error)")
                        }
                        
                    }
                    
                    var index=ParseHelper.parseGetObjectIndexFromArray(self.friends, object: friend)
                    // println("index \(index)")
                    if(index != -1){
                        self.friends.removeAtIndex(index)
                        //self.friends=friends
                    }
                    
                    SweetAlert().showAlert("Deleted!", subTitle: "Your imaginary file has been deleted!", style: AlertStyle.Success)
                }
            }

        }
        
    }

}
