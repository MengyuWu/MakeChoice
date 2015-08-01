//
//  FriendRequestTableViewCell.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/16/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit

protocol FriendRequestTableViewCellDelegate: class {
    func cell(cell:FriendRequestTableViewCell, didSelectAcceptFriend user: PFUser)
    func cell(cell:FriendRequestTableViewCell, didSelectRejectFriend user: PFUser)
}



class FriendRequestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var username: UILabel!
  
    @IBOutlet weak var message: UILabel!
    
    var user:PFUser?{
        didSet{
            username.text=user?.username ?? ""
            self.userImage.image=UIImage(named: "Profile")
            ParseHelper.getUserImage(user){ (data:NSData?, error:NSError?) -> Void in
                if let data=data{
                    self.userImage.image=UIImage(data: data, scale:1)
                }
            }
            
            DesignHelper.setCircleImage(self.userImage)
        }
        
    }
    weak var delegate:FriendRequestTableViewCellDelegate?
    
    @IBAction func acceptFriendButtonTapped(sender: AnyObject) {
        // println("accept in cell")
        self.delegate?.cell(self, didSelectAcceptFriend: self.user!)
   }

    
    @IBAction func rejectFriendButtonTapped(sender: AnyObject) {
       //  println("reject in cell")
        self.delegate?.cell(self, didSelectRejectFriend: self.user!)
        
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
