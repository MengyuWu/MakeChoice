//
//  FriendSearchViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/14/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit

class FriendSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var sendRequestAlertController:UIAlertController?
    
    var selectedUser:PFUser? //
    
    // all the users that match current search
    var users:[PFUser]?
    
    // localCache for friends
    var friends:[PFUser]?{
        didSet{
             tableView.reloadData()
        }
    }
    
    
    //the current parse query
    var query: PFQuery?{
        didSet{
            // get new query, cancel any previous requests
            oldValue?.cancel()
        }
    }
    
    
    enum State {
        
        case DefaultMode
        case SearchMode
        
    }
    
    var state: State = .DefaultMode {
        
        didSet {
            
            switch (state){
                
            case .DefaultMode:
                query = ParseHelper.allUsers(updateList)
                
            case .SearchMode:
                let searchText = searchBar?.text ?? ""
                query=ParseHelper.searchUsers(searchText, completionBlock: updateList)
                
                
            }
            
            
        }
        
    }


    // MARK:update userlist, call back function, get all the search results
    
    func updateList(results: [AnyObject]?, error: NSError?){
        self.users=results as? [PFUser] ?? []
        self.tableView.reloadData()
        
        if let error=error{
            println("error: \(error)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.dataSource=self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        state = .DefaultMode
        // fill the cache of a user's followees
        
        ParseHelper.allFriends{(results: [AnyObject]?, error: NSError?) -> Void in
            
            let relations = results as? [PFObject] ?? []
            // use map to extract the user from a follow object
            
            // objectForKey  Returns the value associated with a given key.
            self.friends = relations.map{ $0.objectForKey(PF_FRIEND_FRIEND) as! PFUser}
            
            if let error = error {
                // Call the default error handler in case of an Error
                //ErrorHandling.defaultErrorHandler(error)
                println("error : \(error)")
            }
            
        }

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

// MARK: TableView Data Source

extension FriendSearchViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users?.count ?? 0
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("friendSearchCell") as! FriendSearchTableViewCell
        
        let user=users![indexPath.row]
        
        cell.user = user
        
        if let friends = friends{
            
            // chekc if current user is already following displayed user
            
            //cell.canAdd = !contains(friends, user)
            
            cell.canAdd = !ParseHelper.parseContains(friends, object: user)
            
            println(" friend objectId: \(friends.first?.objectId) , user objectId: \(user.objectId) , friends contains user? \(contains(friends, user))")
            
        }
        
        // when to set delegate?, when the cell is going to be displayed
        
        cell.delegate = self //set the delegate of friendsearchdelagte to be the viewcontroller
        
        return cell
    }
}

// MARK: FriendSearchTableViewCell Delegate
extension FriendSearchViewController: FriendSearchTableViewCellDelegate{
    

    func sendRequest(alert: UIAlertAction!){
        // store the new word
        println("Send Request")
       if let sendRequestAlertController=sendRequestAlertController{
        if let requestTextFields=sendRequestAlertController.textFields as? [UITextField]{
            var requestText=requestTextFields[0].text ?? ""
            println("request info: \(requestText)")
            
          // save the request to parse, and then send notification
            if let toUser=self.selectedUser{
                ParseHelper.saveAddFriendRequest(toUser, message: requestText){(success: Bool, error:NSError?) ->Void in
                    if success{
                        //send notification
                        println("save add friendRequest success!")
                    }
                    
                    if error != nil{
                        println("save add friend Request error \(error)")
                    }
                    
                }
            }
            
        }
        
     }
        
   }
    
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "Enter something"
       
    }
    
    func cell(cell: FriendSearchTableViewCell, didSelectAddFriend user: PFUser){
       println("add friends button tapped")
        
        self.selectedUser=user
        
        sendRequestAlertController=UIAlertController(title: "Add Friend", message: "Enter request below", preferredStyle: UIAlertControllerStyle.Alert)
        
        if let sendRequestAlertController=sendRequestAlertController{
        sendRequestAlertController.addTextFieldWithConfigurationHandler(addTextField)
        sendRequestAlertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        sendRequestAlertController.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.Default, handler: sendRequest))
        self.presentViewController(sendRequestAlertController, animated: true, completion: nil)
        }
        
        
        
    }
    
    
    func cell(cell: FriendSearchTableViewCell, didSelectRemoveFriend user: PFUser){
        
        if var friends = friends {
          
            println("remove friends \(user.username)")
            
        }
        
    }
    
}
