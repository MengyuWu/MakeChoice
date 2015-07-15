//
//  PushNotification.swift
//
//
//
//  Copyright (c) 2015 Mengyu Wu. All rights reserved.
//

import Foundation
import Parse

class PushNotication {
    
    class func parsePushUserAssign() {
        var installation = PFInstallation.currentInstallation()
        installation[PF_INSTALLATION_USER] = PFUser.currentUser()
        installation.saveInBackgroundWithBlock { (success: Bool, error: NSError? ) -> Void in
            if error != nil {
                println("parsePushUserAssign save error.")
            }
        }
    }
    
    class func parsePushUserResign() {
        var installation = PFInstallation.currentInstallation()
        installation.removeObjectForKey(PF_INSTALLATION_USER)
        installation.saveInBackgroundWithBlock { (success: Bool, error: NSError? ) -> Void in
            if error != nil {
                println("parsePushUserResign save error")
            }
        }
    }
    
    class func sendPushNotification(groupId: String, text: String) {
        var query = PFQuery(className: PF_MESSAGES_CLASS_NAME)
        query.whereKey(PF_MESSAGES_GROUPID, equalTo: groupId)
        query.whereKey(PF_MESSAGES_USER, equalTo: PFUser.currentUser()!)
        query.includeKey(PF_MESSAGES_USER)
        query.limit = 1000
        
        var installationQuery = PFInstallation.query()
      //  installationQuery?.whereKey(PF_INSTALLATION_USER, matchesKey: PF_MESSAGES_USER, inQuery: query)
        installationQuery?.whereKey(PF_INSTALLATION_USER, equalTo:PFUser.currentUser()!)
        
        var push = PFPush()
        push.setQuery(installationQuery)
        push.setMessage(text)
        push.sendPushInBackgroundWithBlock { (success: Bool, error: NSError? ) -> Void in
            if error != nil {
               // println(error)
                println("sendPushNotification error")
            }
        }
    }
    
    
    
    
    
    
    
    
}