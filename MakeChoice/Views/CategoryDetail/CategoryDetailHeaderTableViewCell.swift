//
//  CategoryDetailHeaderTableViewCell.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/20/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit

class CategoryDetailHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var usericon: UIImageView!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    
    var post: Post? {
        didSet{
            if let post=post{
                usernameLabel.text=post.poster?.username
                postTimeLabel.text=post.createdAt?.shortTimeAgoSinceDate(NSDate()) ?? ""
                questionLabel.text=post.title ?? ""
                
                var placeHolderIcon=UIImage(named:"Profile")
                var iconFile=post.poster?[PF_USER_PICTURE] as? PFFile
                if let iconFile=iconFile{
                    iconFile.getDataInBackgroundWithBlock{(data:NSData?, error: NSError?) -> Void in
                        
                        if let error = error {
                            
                            println("category detial header table view cell error:\(error)")
                        }
                        
                        if let data = data {
                            
                            let image = UIImage(data:data, scale: 1.0)!
                            self.usericon.image=image
                            
                        }
                        
                    }
                    
                }
                DesignHelper.setCircleImage(self.usericon)
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
