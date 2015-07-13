//
//  FriendsTableViewCell.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/13/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendPostsNum: UILabel!
    
    
    var friend: PFUser?{
        didSet{
            
            if let friend = friend{
            
            friendName.text=friend.username ?? ""
                
            var imageFile:AnyObject? = friend[PF_USER_PICTURE]
            if let imageFile=imageFile as? PFFile{
                imageFile.getDataInBackgroundWithBlock{
                    (data: NSData?, error: NSError?) -> Void in
                    if let data=data{
                        self.friendImage.image=UIImage(data: data, scale:1)
                    }
                 }
            }else{
                self.friendImage.image=UIImage(named: "Profile")
            }
            
          }
            
        DesignHelper.setCircleImage(self.friendImage)
            
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
