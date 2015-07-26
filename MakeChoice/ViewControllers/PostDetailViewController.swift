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
    
    @IBOutlet weak var commentNum: UILabel!
    
    @IBAction func commentButtonTapped(sender: AnyObject) {
        
      self.performSegueWithIdentifier("commentPushSegue", sender: self.post)
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue){
        if let identifier = segue.identifier {
            
            if (identifier=="commentUnwind") {
                println("commentUnwind")
                if(segue.sourceViewController .isKindOfClass(CommentViewController)){
                    var commentVC=segue.sourceViewController as! CommentViewController
                    var tag=commentVC.index
                    println("index:\(tag)")
               }
                
                
            }
            
        }
    }


    
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
        
        // get comment number
        self.commentNum.text=""
        if let post=post{
            ParseHelper.getCommentNumberWithPostId(post.objectId!){ (results: [AnyObject]?, error:NSError?) -> Void in
                if let results=results{
                    self.commentNum.text=(results.count == 0) ? "": String(results.count)
                }
                
            }
  
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="showUserVoteSegue") {
            let userVoteDetailController = segue.destinationViewController as! UserVoteDetailViewController
            
            userVoteDetailController.postId=post?.objectId ?? ""
        }else if( segue.identifier=="commentPushSegue"){
            let commentVC = segue.destinationViewController as! CommentViewController
            //commentVC.hidesBottomBarWhenPushed = true
            
            if let post=sender as? Post{
                let groupId = post.objectId! as String ?? ""
                commentVC.groupId = groupId
                commentVC.post=post
                
            }
            
            
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
