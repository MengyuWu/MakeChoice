//
//  PushNotificationHelper.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/16/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import Foundation
import Parse

class PushNotificationHelper{
    
    class func sendAddFriendRequesNotification(toUser:PFUser) {
        
        var installationQuery = PFInstallation.query()
        // since one user may have several devices
       installationQuery?.whereKey(PF_INSTALLATION_USER, equalTo:toUser)
        
        var push = PFPush()
        push.setQuery(installationQuery)
        var username=PFUser.currentUser()?.username ?? ""
        var text="\(username) send you a friend request!"
        push.setMessage(text)
        
        var data=["title": "MAKE A CHOICE", "alert": text, "badge":"Increment"]
        push.setData(data)
        
        push.sendPushInBackgroundWithBlock { (success: Bool, error: NSError? ) -> Void in
            if success {
                println("send push in background success")
            }
            if error != nil {
                // println(error)
                println("sendPushNotification error")
            }
        }
    }

    
    class func sendFriendRequesResponseNotification(toUser:PFUser, choice:Int) {
        
        var installationQuery = PFInstallation.query()
        // since one user may have several devices
        installationQuery?.whereKey(PF_INSTALLATION_USER, equalTo:toUser)
        
        var push = PFPush()
        push.setQuery(installationQuery)
        var username=PFUser.currentUser()?.username ?? ""
        var text=""
        if (choice==1) {
          text="\(username) accept your friend request!"
        }else if (choice==2) {
          text="\(username) reject your friend request!"
        }
        push.setMessage(text)
        
//        var data=["title": "MAKE A CHOICE", "alert": text, "badge":"Increment"]
//        push.setData(data)
        
        push.sendPushInBackgroundWithBlock { (success: Bool, error: NSError? ) -> Void in
            if success {
                println("accept friend push in background success")
            }
            if error != nil {
                // println(error)
                println("sendPushNotification error")
            }
        }
    }

    
    class func sendVoteNotification(toUser:PFUser!){
        
        var installationQuery = PFInstallation.query()
        // since one user may have several devices
        installationQuery?.whereKey(PF_INSTALLATION_USER, equalTo:toUser)
        
        var push = PFPush()
        push.setQuery(installationQuery)
        var username=PFUser.currentUser()?.username ?? ""
        var text="\(username) vote !"
        push.setMessage(text)
        var data=["title": "MAKE A CHOICE", "alert": text, "badge":"Increment"]
        push.setData(data)
        
        push.sendPushInBackgroundWithBlock { (success: Bool, error: NSError? ) -> Void in
            if success {
                println("send vote notification success")
            }
            if error != nil {
                // println(error)
                println("sendPushNotification error")
            }
        }

    }
    
    
    class func sendCommentNotification(toUser:PFUser!){
        
        var installationQuery = PFInstallation.query()
        // since one user may have several devices
        installationQuery?.whereKey(PF_INSTALLATION_USER, equalTo:toUser)
        
        var push = PFPush()
        push.setQuery(installationQuery)
        var username=PFUser.currentUser()?.username ?? ""
        var text="\(username) leave a comment!"
        push.setMessage(text)
        var data=["title": "MAKE A CHOICE", "alert": text, "badge":"Increment"]
        push.setData(data)
        
        push.sendPushInBackgroundWithBlock { (success: Bool, error: NSError? ) -> Void in
            if success {
                println("send comment notification success")
            }
            if error != nil {
                // println(error)
                println("sendPushNotification error")
            }
        }
        
    }

    
    
}