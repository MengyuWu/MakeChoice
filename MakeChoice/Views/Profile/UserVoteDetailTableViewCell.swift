//
//  UserVoteDetailTableViewCell.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/13/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit

class UserVoteDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var username: UILabel!
    var vote: PFObject? {
        didSet{
          
            if let vote=vote{
                var user=vote[PF_VOTE_VOTER] as! PFUser
                
                self.username.text=user.username
                
                var imageFile:AnyObject? = user[PF_USER_PICTURE]
                
                if let imageFile=imageFile as? PFFile{
                    
                
                imageFile.getDataInBackgroundWithBlock{
                    (data: NSData?, error: NSError?) -> Void in
                    
                    if let data=data{
                        self.userImageView.image=UIImage(data: data, scale:1)
                        
                    }
                }
                }else{
                     self.userImageView.image=UIImage(named: "Profile")
                }
            }
            
            DesignHelper.setCircleImage(self.userImageView)
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
