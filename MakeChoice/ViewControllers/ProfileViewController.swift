//
//  ProfileViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/12/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var YourPostsContainerView: UIView!
    
    @IBOutlet weak var FriendsContainerView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var userImage: UIImageView!
    
  
    @IBOutlet weak var username: UILabel!
    

    @IBAction func indexChanged(sender: AnyObject) {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            NSLog("Your post")
            YourPostsContainerView.hidden=false
            FriendsContainerView.hidden=true
        case 1:
            NSLog("your friends")
            YourPostsContainerView.hidden=true
            FriendsContainerView.hidden=false
        default:
            break;
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
        }
        
        
        DesignHelper.setCircleImage(self.userImage)
        self.userImage.backgroundColor=UIColor.whiteColor()
        

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

extension ProfileViewController: UIImagePickerControllerDelegate{
    
}

extension ProfileViewController: UINavigationControllerDelegate {
    
}
