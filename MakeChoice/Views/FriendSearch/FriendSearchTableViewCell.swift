//
//  FriendSearchTableViewCell.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/14/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit

protocol FriendSearchTableViewCellDelegate: class {
    func cell(cell: FriendSearchTableViewCell, didSelectAddFriend user: PFUser)
    
}

class FriendSearchTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var addFriendButton: UIButton!
    
    @IBAction func addFriendButtonTapped(sender: AnyObject) {
        
        if let user=self.user{
         
            if let canAdd=canAdd where canAdd == true{
                delegate?.cell(self, didSelectAddFriend: user)
                self.canAdd=false
                self.addFriendButton.enabled=false
                
            }
       
        }
    }
 
    
    weak var delegate:FriendSearchTableViewCellDelegate?
    
    var user:PFUser?{
        didSet{
            username.text=user?.username ?? ""
            if let user=user{
            
            var imageFile:AnyObject? = user[PF_USER_PICTURE]
            if let imageFile=imageFile as? PFFile{
                imageFile.getDataInBackgroundWithBlock{
                    (data: NSData?, error: NSError?) -> Void in
                    if let data=data{
                        self.userImage.image=UIImage(data: data, scale:1)
                    }
                }
            }else{
                self.userImage.image=UIImage(named: "Profile")
            }
            
        }
        
        DesignHelper.setCircleImage(self.userImage)
        }
    }
    
    
    var canAdd: Bool? = true {
        
        didSet{
            /*
            Change the state of the follow button based on whether or not
            it is possible to follow a user.
            */
            if let canAdd = canAdd {
                addFriendButton.enabled = canAdd
            }
        }
        
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
