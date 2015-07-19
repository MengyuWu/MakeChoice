//
//  YourPostsTableViewCell.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/12/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit
import Bond

protocol YourPostsTableViewCellDelegate: class{
    func cell(cell: YourPostsTableViewCell, didSelectAddressBookSegue post: Post)
    func cell(cell: YourPostsTableViewCell, didSelectShareToFacebook post: Post)
    func presentViewController(alertController:UIAlertController)
}


class YourPostsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var img1: UIImageView!
    
    @IBOutlet weak var img2: UIImageView!
    
    @IBOutlet weak var totalVotes: UILabel!
    
    @IBOutlet weak var vote1: UILabel!
    
    @IBOutlet weak var vote2: UILabel!
    
    @IBOutlet weak var title: UILabel!
    
    var delegate:YourPostsTableViewCellDelegate?
    
    @IBAction func helpButtonTapped(sender: AnyObject) {
        
        let alertController = UIAlertController(title: nil, message: "Poll", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        
        let addressBookAction = UIAlertAction(title: "AddressBook", style: .Default){ (action) in
            delegate?.cell(self, didSelectAddressBookSegue: post!)
        }
        alertController.addAction(addressBookAction)
        
        
        let shareToFaceBookAction=UIAlertAction(title: "Facebook", style: .Default){ (action) in
            delegate?.cell(self, didSelectShareToFacebook: post!)
        }
        alertController.addAction(shareToFaceBookAction)
        
        delegate?.presentViewController(alertController)
        
    }
    
    
    
    var post:Post? {
        didSet {
            
            //oldValue is aviable automatically in the didSet, it allow to access the previous value of a property
            
            if let oldValue = oldValue where oldValue != post {
                
                
                
                img1.designatedBond.unbindAll()
                img2.designatedBond.unbindAll()
                totalVotes.designatedBond.unbindAll()
                vote1.designatedBond.unbindAll()
                vote2.designatedBond.unbindAll()
                
            }
            
            
            if let post = post{
                // bind the image of the post to the postImage view
                post.image1 ->> img1
                post.image2 ->> img2
                
                //bind the totalVotes , vote1, vote2
                map(post.totalVotesInt){ "\($0)" } ->> self.totalVotes
                map(post.vote1Percentage){ "\($0)" } ->> self.vote1
                map(post.vote2Percentage){ "\($0)" } ->> self.vote2
                
                
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

