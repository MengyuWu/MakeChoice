//
//  ProfileViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/12/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ParseFacebookUtilsV4

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var YourPostsContainerView: UIView!
    
    @IBOutlet weak var FriendsContainerView: UIView!
    var friendsVC: FriendsListViewController?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var userImage: UIImageView!
    
  
    @IBOutlet weak var username: UILabel!
    
    var parseLoginHelper: ParseLoginHelper!
    
    

    @IBAction func indexChanged(sender: AnyObject) {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            NSLog("Your post")
            YourPostsContainerView.hidden=false
            FriendsContainerView.hidden=true
            //YourPostsContainerView.setNeedsDisplay()
        case 1:
            NSLog("your friends")
            YourPostsContainerView.hidden=true
            FriendsContainerView.hidden=false
        
            if self.friendsVC == nil{
                println("nil")
            }
            
          //  self.friendsVC?.tableView.reloadData()
          //  self.friendsVC?.view.setNeedsDisplay()
            //FriendsContainerView.setNeedsDisplay()
            
            
        default:
            break;
        }
        
        
    }
 

@IBAction func logoutButtonTapped(sender: AnyObject) {
    println("logout button ")
    
    PFUser.logOut()
    self.goToLogin()
    
    }
    
    func goToLogin(){
        let loginViewController = PFLogInViewController()
        loginViewController.fields = .UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten | .Facebook
        loginViewController.delegate = parseLoginHelper
        loginViewController.signUpController?.delegate = parseLoginHelper
        loginViewController.logInView?.logo?.hidden=true
        
        self.presentViewController(loginViewController, animated: true, completion: nil)
        
    }
    
 @IBOutlet weak var requestButton: MIBadgeButton!
 
    @IBAction func requestButtonTapped(sender: AnyObject) {
        
        self.performSegueWithIdentifier("friendRequestSegue", sender: self)
        
        //clean badge value
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set badge value position, top right
        self.requestButton.badgeEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 15)
        
        // LOGOUT
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            // Initialize the ParseLoginHelper with a callback
            if let error = error {
                // 1
                // ErrorHandling.defaultErrorHandler(error)
                println(error)
            } else  if let user = user {
                // if login was successful, display the TabBarController
                // 2
                println("login user \(user)")
                
                // if login again, dismiss the login view
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
 }
    
   
    
    override func viewWillAppear(animated: Bool) {
        // Do any additional setup after loading the view.
        
       var user:PFUser?=PFUser.currentUser()
       self.username.text=user?.username ?? ""
        
        // get user image
        if let user=user {
            var imageFile: AnyObject? = user[PF_USER_PICTURE]
            
            if let imageFile=imageFile as? PFFile{
                
                
                imageFile.getDataInBackgroundWithBlock{
                    (data: NSData?, error: NSError?) -> Void in
                    
                    if let data=data{
                        println("get data")
                        self.userImage.image=UIImage(data: data, scale:1)
                        
                    }
                }
            }else{
                self.userImage.image=UIImage(named: "Profile")
            }
            
            DesignHelper.setImageClipsToBounds(self.userImage)
            
        }
        
        DesignHelper.setCircleImage(self.userImage)
        self.userImage.backgroundColor=UIColor.whiteColor()
        
        //set add friends request badge value
        ParseHelper.getFriendsRequest{ (results:[AnyObject]?, error:NSError?) -> Void in
            if let results=results{
                var num=results.count
                if (num != 0) {
                    self.requestButton.badgeString="\(num)"
                }else{
                    self.requestButton.badgeString=nil
                }
            }
            
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if( segue.identifier=="friendRequestSegue"){
            let friendRequstViewController = segue.destinationViewController as! FriendRequestViewController
        }
        if( segue.identifier=="FriendListSegue"){
            println("friendlistsegue")
            self.friendsVC = segue.destinationViewController as? FriendsListViewController
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

extension ProfileViewController: UIImagePickerControllerDelegate{
    
}

extension ProfileViewController: UINavigationControllerDelegate {
    
}
