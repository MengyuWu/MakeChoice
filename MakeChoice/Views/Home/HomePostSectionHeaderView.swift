//
//  HomePostSectionHeaderView.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/9/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit



class HomePostSectionHeaderView: UITableViewCell {

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
                
               //Change line if too long
                questionLabel.lineBreakMode = .ByWordWrapping
                questionLabel.numberOfLines=0
                               
               
                var placeHolderIcon=UIImage(named:"Profile")
                var iconFile=post.poster?[PF_USER_PICTURE] as? PFFile
                if let iconFile=iconFile{
                    iconFile.getDataInBackgroundWithBlock{(data:NSData?, error: NSError?) -> Void in
                    
                        if let error = error {
                           // ErrorHandling.defaultErrorHandler(error)
                            println("error:\(error)")
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
    
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        questionLabel.preferredMaxLayoutWidth = questionLabel.bounds.width
    }
    

}
