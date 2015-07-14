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
    
    var friends:[PFUser]=[]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.dataSource=self
        self.tableView.delegate=self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        ParseHelper.allFriends{ (results:[AnyObject]?, error: NSError?) -> Void in
            if let results = results as? [PFObject]{
            
                self.friends=results.map{$0[PF_FRIEND_FRIEND] as! PFUser}
                println("friends in view will apper: \(self.friends.count)")
                self.tableView.reloadData()
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
        
        println("friends: \(self.friends.count)")
        
        let cell=tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as! FriendsTableViewCell
        
        cell.friend=self.friends[indexPath.row]
        
        return cell
    }

}

extension FriendsListViewController:UITableViewDelegate{
    
}
