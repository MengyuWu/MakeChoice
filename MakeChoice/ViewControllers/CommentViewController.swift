//
//  CommentViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/14/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer
import JSQMessagesViewController

class CommentViewController: JSQMessagesViewController{
    
    var groupId:String="" // groupId is eaqual to postId
    var post:Post?
    var index:Int?
    
    var timer: NSTimer = NSTimer()
    var isLoading: Bool = false
    var users = [PFUser]()
    var messages = [JSQMessage]()
    var avatars = Dictionary<String, JSQMessagesAvatarImage>()
    
    var bubbleFactory = JSQMessagesBubbleImageFactory()
    var outgoingBubbleImage: JSQMessagesBubbleImage!
    var incomingBubbleImage: JSQMessagesBubbleImage!
    
    var blankAvatarImage: JSQMessagesAvatarImage!
    
    var senderImageUrl: String!
    var batchMessages = true
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var user=PFUser.currentUser()
        if let user=user{
            self.senderId=user.objectId!
            self.senderDisplayName = user.username ?? ""
        }
        
        outgoingBubbleImage = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImage = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        
        blankAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "Profile"), diameter: 30)
        
        // configure the placeholder text
        self.inputToolbar.contentView.textView.placeHolder = "New Comment"
        
        isLoading = false
        self.loadMessages()
        Messages.clearMessageCounter(groupId);
        
                
        
    }
    
    
    func hideTabBar(flag:Bool) {
    
        if let atc = self.navigationController?.tabBarController as? RAMAnimatedTabBarController{
            let icons  = atc.iconsView
            
            if (flag == true ) {
                atc.tabBar.hidden = true
                for icon in icons {
                    icon.icon.hidden = true
                    icon.textLabel.hidden = true
                    icon.icon.superview?.hidden = true
                }
            } else {
                atc.tabBar.hidden = false
                for icon in icons {
                    if let sup = icon.icon.superview{
                        sup.hidden = false
                        // bring the icon superview to the front 
                        sup.superview?.bringSubviewToFront(sup)
                    }
                    icon.icon.hidden = false
                    icon.textLabel.hidden = false
                }
            }
 
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if var tabBarController=self.navigationController?.tabBarController as? RAMAnimatedTabBarController{
           self.hideTabBar(true)
           
        }

    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if var tabBarController=self.navigationController?.tabBarController as? RAMAnimatedTabBarController{
            self.hideTabBar(false)
            
        }
        

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    // Mark: - Backend methods
    
    func loadMessages() {
        if self.isLoading == false {
            self.isLoading = true
            var lastMessage = messages.last
            
            var query = PFQuery(className: PF_COMMENT_CLASS_NAME)
            query.whereKey(PF_COMMENT_GROUPID, equalTo: groupId)
            if let lastMessage = lastMessage {
                query.whereKey(PF_COMMENT_CREATEDAT, greaterThan: lastMessage.date)
            }
            query.includeKey(PF_COMMENT_USER)
            query.orderByDescending(PF_COMMENT_CREATEDAT)
            query.limit = 50
            query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    self.automaticallyScrollsToMostRecentMessage = false
                    
                    if let objects=objects {
                        for object in (objects as! [PFObject]).reverse() {
                            
                            self.addMessage(object)
                        }
                        
                        
                        if objects.count > 0 {
                            self.finishReceivingMessage()
                            self.scrollToBottomAnimated(false)
                        }
                    }
                    self.automaticallyScrollsToMostRecentMessage = true
                } else {
             
                    println("network error")
                }
                self.isLoading = false;
            })

        }
    }
    
    
    func addMessage(object: PFObject) {
        var message: JSQMessage!
        
        var user = object[PF_COMMENT_USER] as! PFUser
        var name = user.username ?? ""
        
        var videoFile = object[PF_COMMENT_VIDEO] as? PFFile
        var pictureFile = object[PF_COMMENT_PICTURE] as? PFFile
        
        if videoFile == nil && pictureFile == nil {
            message = JSQMessage(senderId: user.objectId, senderDisplayName: name, date: object.createdAt, text: (object[PF_COMMENT_TEXT] as? String))
        }
        if videoFile != nil {
            var mediaItem = JSQVideoMediaItem(fileURL: NSURL(string: videoFile!.url!), isReadyToPlay: true)
            message = JSQMessage(senderId: user.objectId, senderDisplayName: name, date: object.createdAt, media: mediaItem)
        }
        
        if pictureFile != nil {
            var mediaItem = JSQPhotoMediaItem(image: nil)
            mediaItem.appliesMediaViewMaskAsOutgoing = (user.objectId == self.senderId)
            message = JSQMessage(senderId: user.objectId, senderDisplayName: name, date: object.createdAt, media: mediaItem)
            
            pictureFile!.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData=imageData{
                        mediaItem.image = UIImage(data: imageData)
                        self.collectionView.reloadData()
                    }
                }
            })
        }
        
        users.append(user)
        messages.append(message)
    }
    
    
    func sendMessage(var text: String, video: NSURL?, picture: UIImage?) {
        var videoFile: PFFile!
        var pictureFile: PFFile!
        
        if let video = video {
            text = "[Video message]"
            videoFile = PFFile(name: "video.mp4", data: NSFileManager.defaultManager().contentsAtPath(video.path!)!)
            
            videoFile.saveInBackgroundWithBlock({ (succeeed: Bool, error: NSError?) -> Void in
                if error != nil {
                   
                    println("network error")
                    
                }
            })
        }
        
        if let picture = picture {
            text = "[Picture message]"
            pictureFile = PFFile(name: "picture.jpg", data: UIImageJPEGRepresentation(picture, 0.6))
            pictureFile.saveInBackgroundWithBlock({ (suceeded: Bool, error: NSError?) -> Void in
                if error != nil {
                  
                    println("picture save error")
                }
            })
        }
        
        var object = PFObject(className: PF_COMMENT_CLASS_NAME)
        object[PF_COMMENT_USER] = PFUser.currentUser()
        object[PF_COMMENT_GROUPID] = self.groupId
        object[PF_COMMENT_TEXT] = text
        if let videoFile = videoFile {
            object[PF_COMMENT_VIDEO] = videoFile
        }
        if let pictureFile = pictureFile {
            object[PF_COMMENT_PICTURE] = pictureFile
        }
        object.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                JSQSystemSoundPlayer.jsq_playMessageSentSound()
                self.loadMessages()
            } else {
       
                println("network error")
            }
        }
        
        //pushNotification, if currentuser is not poster, push notification
        if(post?.poster?.objectId != PFUser.currentUser()?.objectId){
            
            if let post=post{
                ParseHelper.uploadNotification(PFUser.currentUser()!, toUser: post.poster!, messageType: "comment", post: post)
                
                PushNotificationHelper.sendCommentNotification(post.poster)
            }
            
           
        }

        Messages.updateMessageCounter(groupId, lastMessage: text)
        
        self.finishSendingMessage()
    }

    
    // MARK: - JSQMessagesViewController method overrides
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        self.sendMessage(text, video: nil, picture: nil)
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        var action = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil,otherButtonTitles: "Take photo", "Choose existing photo", "Choose existing video")
        
        action.showInView(self.view)
    }

    
    
    // MARK: - UICollectionView flow layout
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        var message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return 0
        }
        
        if indexPath.item - 1 > 0 {
            var previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == message.senderId {
                return 0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 0
    }

    
    // MARK: - Responding to CollectionView tap events
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        println("didTapLoadEarlierMessagesButton")
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, atIndexPath indexPath: NSIndexPath!) {
        println("didTapAvatarImageview")
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        println("didTapMessageBubbleAtIndexPath")
        var message = self.messages[indexPath.item]
        if message.isMediaMessage {
            if let mediaItem = message.media as? JSQVideoMediaItem {
                var moviePlayer = MPMoviePlayerViewController(contentURL: mediaItem.fileURL)
                self.presentMoviePlayerViewControllerAnimated(moviePlayer)
                moviePlayer.moviePlayer.play()
            }
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapCellAtIndexPath indexPath: NSIndexPath!, touchLocation: CGPoint) {
        println("didTapCellAtIndexPath")
    }



}

// MARK: - UIActionSheetDelegate
extension CommentViewController:UIActionSheetDelegate {
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != actionSheet.cancelButtonIndex {
            //1."Take photo", 2."Choose existing photo", 3."Choose existing video"
            if buttonIndex == 1 {
                Camera.shouldStartCamera(self, canEdit: true, frontFacing: true)
            } else if buttonIndex == 2 {
                Camera.shouldStartPhotoLibrary(self, canEdit: true)
            } else if buttonIndex == 3 {
                Camera.shouldStartVideoLibrary(self, canEdit: true)
            }
        }
        
    }
}



// MARK: - JSQMessages CollectionView DataSource

extension CommentViewController:UICollectionViewDataSource {
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        var message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return outgoingBubbleImage
        }
        return incomingBubbleImage
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        var user = self.users[indexPath.item]
        if self.avatars[user.objectId!] == nil {
            var thumbnailFile = user[PF_USER_PICTURE] as? PFFile
            if let thumbnailFile=thumbnailFile {
                thumbnailFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData=imageData {
                            self.avatars[user.objectId!] = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(data: imageData), diameter: 30)
                            self.collectionView.reloadData()
                        }
                    }
                })
            }
            return blankAvatarImage
        } else {
            return self.avatars[user.objectId!]
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        if indexPath.item % 3 == 0 {
            var message = self.messages[indexPath.item]
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        return nil;
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        var message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return nil
        }
        
        if indexPath.item - 1 > 0 {
            var previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == message.senderId {
                return nil
            }
        }
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        return nil
    }
}

// MARK: - UICollectionView DataSource
extension CommentViewController:UICollectionViewDataSource{
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        var message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            cell.textView?.textColor = UIColor.whiteColor()
        } else {
            cell.textView?.textColor = UIColor.blackColor()
        }
        return cell
    }
    
}


extension CommentViewController:UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var video = info[UIImagePickerControllerMediaURL] as? NSURL
        var picture = info[UIImagePickerControllerEditedImage] as? UIImage
        
        self.sendMessage("", video: video, picture: picture)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension CommentViewController:UINavigationControllerDelegate{
    
}