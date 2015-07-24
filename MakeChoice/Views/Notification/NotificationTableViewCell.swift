//
//  NotificationTableViewCell.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/24/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var typeImage: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var time: UILabel!
    

    var notification:PFObject?{
        didSet{
            if let notification=notification{
               
                var fromUser=notification[PF_NOTIFICATION_FROMUSER] as! PFUser
                var messageType=notification[PF_NOTIFICATION_MESSAGETYPE] as! String
                var timelapse=notification.createdAt?.shortTimeAgoSinceDate(NSDate()) ?? ""
                
                
                self.username.text=fromUser.username
                self.time.text=timelapse
                
                if( messageType=="vote") {
                    self.typeImage.image=UIImage(named: "Comment")
                    self.message.text="voted on you poll"
                    
                }else if (messageType=="comment"){
                    self.typeImage.image=UIImage(named: "Vote")
                    self.message.text="commented on you poll"
                }
                
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
