//
//  MaveSDKHelper.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/30/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import Foundation
import Parse
import MaveSDK

class MaveSDKHelper{
    
    static func setupMaveSDK(){
        var mave=MaveSDK.sharedInstance()
        var user=PFUser.currentUser()
        if let user=user{
            var userData=MAVEUserData(userID: user.objectId, firstName:user.username, lastName: "")
            mave.identifyUser(userData)
        }
        
    }

    
    
}