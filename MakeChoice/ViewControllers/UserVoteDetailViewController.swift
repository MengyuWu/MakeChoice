//
//  UserVoteDetailViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/13/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit

class UserVoteDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var postId:String?=""
    
    var votes:[PFObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
      tableView.delegate=self
      tableView.dataSource=self
        
    }
 
    //TODO: need to have some better way to cache something unchanged
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        println("view will appear")
        ParseHelper.findVotesWithPostId(self.postId ?? ""){
            (results: [AnyObject]?, error: NSError?) -> Void in
            if let results=results as? [PFObject]{
                self.votes=results
                println("results count: \(self.votes.count)")
                
                // reload data
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

// MARK: delegate and dataSource

extension UserVoteDetailViewController: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        println("number of rows: \(votes.count)")
       return votes.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
         let cell=tableView.dequeueReusableCellWithIdentifier("userVoteCell", forIndexPath: indexPath) as! UserVoteDetailTableViewCell
      
        println("in cell for row at Index path")
        
       cell.vote = self.votes[indexPath.row]
       return cell
        
    }
}

extension UserVoteDetailViewController: UITableViewDelegate{
    
}