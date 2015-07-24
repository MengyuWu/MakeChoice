//
//  postDetailViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/13/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    var post:Post?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var img1: UIImageView!
    
    @IBOutlet weak var img2: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text=post?.title ?? ""
        img1.image=post?.image1.value
        img2.image=post?.image2.value
        
        DesignHelper.setImageClipsToBounds(img1)
        DesignHelper.setImageClipsToBounds(img2)
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
        titleLabel.text=post?.title ?? ""
        img1.image=post?.image1.value
        img2.image=post?.image2.value
        
        DesignHelper.setImageClipsToBounds(img1)
        DesignHelper.setImageClipsToBounds(img2)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="showUserVoteSegue") {
            let userVoteDetailController = segue.destinationViewController as! UserVoteDetailViewController
            
            userVoteDetailController.postId=post?.objectId ?? ""
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

}
