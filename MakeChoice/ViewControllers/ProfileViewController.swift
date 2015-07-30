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
    
    var imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var myPostsNum: UILabel!
    @IBOutlet weak var myFriendsNum: UILabel!
    
    @IBOutlet weak var myPostsView: UIView!
    
    @IBOutlet weak var myFriendsView: UIView!

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
    //self.goToLogin()
    
    // go to animation page
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var animationViewController = storyboard.instantiateViewControllerWithIdentifier("AnimationViewController") as!
    AnimationViewController
    
    
    
    self.presentViewController(animationViewController, animated: true, completion: nil)
    
    
    }
    
    func goToLogin(){
        let loginViewController = PFLogInViewController()
        loginViewController.fields = .UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten | .Facebook
        loginViewController.delegate = parseLoginHelper
        loginViewController.signUpController?.delegate = parseLoginHelper
        
        loginViewController.logInView?.logo?.hidden=true
        loginViewController.signUpController?.signUpView?.logo?.hidden=true
        
        self.presentViewController(loginViewController, animated: true, completion: nil)
        
    }
    
 @IBOutlet weak var requestButton: MIBadgeButton!
 
    @IBAction func requestButtonTapped(sender: AnyObject) {
        
        self.performSegueWithIdentifier("friendRequestSegue", sender: self)
        
        //clean badge value
        
        
    }
    
    
    @IBOutlet weak var notificationButton: MIBadgeButton!
    
    @IBAction func notificationButtonTapped(sender: AnyObject) {
       println("notification button tapped")
       // clean the badge value when tapped(notification badge, and icon badge)
        var currentInstallation=PFInstallation.currentInstallation()
        if (currentInstallation.badge != 0) {
            // clean it
            currentInstallation.badge=0
            currentInstallation.saveEventually()
        }
        
        // Also reset the item badge value, only show friends requests
        
        if var tabBarController=self.navigationController?.tabBarController{
            println("get tabBarController")
            ParseHelper.updateProfileTabBadgeValue(tabBarController)
        }

       self.performSegueWithIdentifier("notificationSegue", sender: self)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set badge value position, top right
        self.requestButton.badgeEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 15)
        self.notificationButton.badgeEdgeInsets=UIEdgeInsetsMake(10, 0, 0, 15)
        
        
        
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
        
        
       // add tap gesture to upload profile image
        imagePickerController.delegate=self
        var profileImagetapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("showPhotoSourceSelection") )
        userImage.addGestureRecognizer(profileImagetapped)
        userImage.userInteractionEnabled = true
        
      // Method2: segment choose
        myPostsView.userInteractionEnabled=true
        var  myPostsViewTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("myPostsViewTapped:" ))
        
        myPostsView.addGestureRecognizer(myPostsViewTapped)
        
        
        
        
        myFriendsView.userInteractionEnabled=true
        var  myFriendsViewTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("myFriendsViewTapped:" ))

        myFriendsView.addGestureRecognizer(myFriendsViewTapped)
        
    
    }
    
    
    
    
    
    func myPostsViewTapped(recognizer:UITapGestureRecognizer ){
        NSLog("Your post")
        YourPostsContainerView.hidden=false
        FriendsContainerView.hidden=true
        
        UICustomSettingHelper.profileSegmentChanged(myPostsView, deselectedItem: myFriendsView)
    }
    
    func myFriendsViewTapped(recognizer:UITapGestureRecognizer ){
        NSLog("your friends")
        YourPostsContainerView.hidden=true
        FriendsContainerView.hidden=false
        UICustomSettingHelper.profileSegmentChanged(myFriendsView, deselectedItem: myPostsView)
    }

    
    func notificationReceived()
    {
        //updateUI
        println("notification badge value")
        // set the notification badge value
        var currentInstallation=PFInstallation.currentInstallation()
        if (currentInstallation.badge != 0) {
            self.notificationButton.badgeString="\(currentInstallation.badge)"
        }else{
            self.notificationButton.badgeString=nil
        }
        
        //update friends request badge value
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
    
    func deleteFriendReceived(){
        //update the statistic friend number
        println("deleteFriend received")
        
        if var numString=self.myFriendsNum.text{
            
            if var num=numString.toInt(){
                if num>0{
                  self.myFriendsNum.text="\(num-1)"
                }
                
            }
            
        }
        
        
        
    }
    
    func deletePostReceived(){
        println("deletePost received")
        if var numString=self.myPostsNum.text{
            
            if var num=numString.toInt(){
                if num>0{
                    self.myPostsNum.text="\(num-1)"
                }
                
            }
            
        }


    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
      
        //listening the broadcast from push notification, must delete it before leave it
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notificationReceived", name: "Received Notification", object: UIApplication.sharedApplication().delegate)
        
        //listening the broadcast from delete friends, object is received object
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "deleteFriendReceived", name: "DeleteFriend", object: nil)
        
        //listening the broadcast from delete post, object is received object
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deletePostReceived", name: "DeletePost", object: nil)

        
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
            
            self.myPostsNum.text=""
            self.myFriendsNum.text=""
            // get myPostsNum and myFriendNum
            
            
            ParseHelper.getNumOfPostsOfUser(user){ (results:[AnyObject]?, error:NSError?) in
                
                if let results=results{
                    self.myPostsNum.text="\(results.count)"
                }
                         
            }
            
            ParseHelper.getFriendsNum{ (results:[AnyObject]?, error:NSError?) in
                
                if let results=results{
                    self.myFriendsNum.text="\(results.count)"
                }

            }
            
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
        
        // set the notification badge value
        var currentInstallation=PFInstallation.currentInstallation()
        if (currentInstallation.badge != 0) {
           self.notificationButton.badgeString="\(currentInstallation.badge)"
        }else{
           self.notificationButton.badgeString=nil
        }

        // update badge value
        if var tabBarController=self.navigationController?.tabBarController{
            println("get tabBarController")
            ParseHelper.updateProfileTabBadgeValue(tabBarController)
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if( segue.identifier=="friendRequestSegue"){
            let friendRequstViewController = segue.destinationViewController as! FriendRequestViewController
        }else if( segue.identifier=="FriendListSegue"){
            // remove this useless
            println("friendlistsegue")
            self.friendsVC = segue.destinationViewController as? FriendsListViewController
        }else if( segue.identifier=="notificationSegue"){
            let notificationViewController = segue.destinationViewController as! NotificationViewController
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
    
    
    // MARK: image picker
    
    func showPhotoSourceSelection() {
        println("picker")
        let alertController = UIAlertController(title: nil, message: "where do you want to get your picture from?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if (UIImagePickerController.isCameraDeviceAvailable(.Rear)){
            let cameraAction = UIAlertAction(title: "Photo from Camera", style: .Default){ (action) in
                self.showImagePickerController(.Camera)
            }
            
            alertController.addAction(cameraAction)
        }
        
        let photoLibrayAction = UIAlertAction(title: "Photo from Libray", style: .Default){ (action) in
            self.showImagePickerController(.PhotoLibrary)
        }
        
        alertController.addAction(photoLibrayAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    

    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType){
        
        imagePickerController.sourceType=sourceType
        imagePickerController.delegate=self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }

    

}

// MARK: delegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        // upload image to parse
        println("finish picking image")
        var imgData=UIImageJPEGRepresentation(image, 0.8)
        let imageFile=PFFile(data: imgData)
        imageFile.saveInBackgroundWithBlock{
            (success: Bool, error: NSError? ) -> Void in
            
            if let error = error {
                // ErrorHandling.defaultErrorHandler(error)
                println("error")
            }else{
                println("profile image save successfully")
                
                var user:PFUser?=PFUser.currentUser()
                if let user=user{
                user[PF_USER_PICTURE]=imageFile
                    user.saveInBackgroundWithBlock{
                         (success: Bool, error: NSError? ) -> Void in
                        if (success){
                        self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        
                    }
              
                }
                
            }
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
