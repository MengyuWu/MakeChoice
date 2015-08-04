//
//  FriendSearchViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/14/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit
import ConvenienceKit
import MBProgressHUD
import MaveSDK

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
                UICustomSettingHelper.MBProgressHUDSimple(self.view)
                query = ParseHelper.allUsers(updateList)
                
            case .SearchMode:
                UICustomSettingHelper.MBProgressHUDSimple(self.view)
                let searchText = searchBar?.text ?? ""
                query=ParseHelper.searchUsers(searchText, completionBlock: updateList)
                
                
            }
            
            
        }
        
    }


    // MARK:update userlist, call back function, get all the search results
    
    func updateList(results: [AnyObject]?, error: NSError?){
         MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        self.users=results as? [PFUser] ?? []
        self.tableView.reloadData()
        
        if let error=error{
            println("FriendSearchViewController: error: \(error)")
            UICustomSettingHelper.sweetAlertNetworkError()
        }
    }
    
    @IBAction func inviteButtonPressed(sender: AnyObject) {
        MaveSDKHelper.setupMaveSDK()
        var mave=MaveSDK.sharedInstance()
        var user=PFUser.currentUser()
        if let user=user{
            var userData=MAVEUserData(userID: user.objectId, firstName:user.username, lastName: "")
            mave.identifyUser(userData)
        }
        
        mave.presentInvitePageModallyWithBlock({(inviteController) -> Void in
             self.presentViewController(inviteController, animated: true, completion: nil)
            }, dismissBlock:{(controller , numberOfInvitesSent) -> Void in
             self.dismissViewControllerAnimated(true, completion: nil)
            }, inviteContext: "default")

   
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.dataSource=self
        self.searchBar.delegate=self
        
      
        
        
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
                UICustomSettingHelper.sweetAlertNetworkError()
            }
            
        }

    }
    

   
}

// MARK: TableView Data Source

extension FriendSearchViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users?.count ?? 0
    }
 
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("friendSearchCell") as! FriendSearchTableViewCell
        
        let user=users![indexPath.row]
        
        cell.user = user
        
        if let friends = friends{
            
            // chekc if current user is already following displayed user
              cell.canAdd = !ParseHelper.parseContains(friends, object: user)
            
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
    
       if let sendRequestAlertController=sendRequestAlertController{
        if let requestTextFields=sendRequestAlertController.textFields as? [UITextField]{
            var requestText=requestTextFields[0].text ?? ""
            //println("request info: \(requestText)")
            
          // save the request to parse, and then send notification
            if let toUser=self.selectedUser{
                UICustomSettingHelper.MBProgressHUDSimple(self.view)
                ParseHelper.saveAddFriendRequest(toUser, message: requestText){(success: Bool, error:NSError?) ->Void in
                    
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    if success{
                        //send notification
                    PushNotificationHelper.sendAddFriendRequesNotification(toUser)
                        
                        SweetAlert().showAlert("Sent!", subTitle: "Friend request sends successfully!", style: AlertStyle.Success)
                    }
                    
                    if error != nil{
                        println("save add friend Request error \(error)")
                        UICustomSettingHelper.sweetAlertNetworkError()
                    }
                    
                }
            }
            
        }
        
     }
        
   }
    
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "Character limits: 30"
        textField.delegate=self
       
    }
    
    func cell(cell: FriendSearchTableViewCell, didSelectAddFriend user: PFUser){
        self.selectedUser=user
        
        sendRequestAlertController=UIAlertController(title: "Add Friend", message: "Enter message below.", preferredStyle: UIAlertControllerStyle.Alert)
        
        if let sendRequestAlertController=sendRequestAlertController{
        sendRequestAlertController.addTextFieldWithConfigurationHandler(addTextField)
        sendRequestAlertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        sendRequestAlertController.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.Default, handler: sendRequest))
        self.presentViewController(sendRequestAlertController, animated: true, completion: nil)
        }
        
        
        
    }
    

    
}

// MARK: UITextFieldDelegate
extension FriendSearchViewController:UITextFieldDelegate{
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if (range.length + range.location > count(textField.text) )
        {
            return false;
        }
        
        let newLength = count(textField.text) + count(string) - range.length
        return newLength <= 30
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



// MARK: Searchbar Delegate

extension FriendSearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(true, animated: true)
        self.state = State.SearchMode
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder() //hide keyboards
        searchBar.text=""
        searchBar.setShowsCancelButton(false, animated: true)
        
        self.state = State.DefaultMode
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        ParseHelper.searchUsers(searchText, completionBlock: updateList)
    }
}

