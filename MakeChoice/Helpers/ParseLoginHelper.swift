//
//  ParseLoginHelper.swift
//  Makestagram
//
//  Created by Benjamin Encz on 4/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import Parse
import ParseUI
import Alamofire

typealias ParseLoginHelperCallback = (PFUser?, NSError?) -> Void

/** 
  This class implements the 'PFLogInViewControllerDelegate' protocol. After a successfull login
  it will call the callback function and provide a 'PFUser' object.
*/
class ParseLoginHelper : NSObject, NSObjectProtocol {
  static let errorDomain = "com.makeschool.parseloginhelpererrordomain"
  static let usernameNotFoundErrorCode = 1
  static let usernameNotFoundLocalizedDescription = "Could not retrieve Facebook username"

  let callback: ParseLoginHelperCallback
  
  init(callback: ParseLoginHelperCallback) {
    self.callback = callback
  }
}

extension ParseLoginHelper : PFLogInViewControllerDelegate {
  
  
  func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
    // Determine if this is a Facebook login
    let isFacebookLogin = FBSDKAccessToken.currentAccessToken() != nil

    if !isFacebookLogin {
      // Plain parse login, we can return user immediately
      self.callback(user, nil)
    } else {
      // if this is a Facebook login, fetch the username from Facebook
      FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler {
        (connection: FBSDKGraphRequestConnection!, result: AnyObject?, error: NSError?) -> Void in
          if let error = error {
            // Facebook Error? -> hand error to callback
            self.callback(nil, error)
          }
        
          if let fbUsername = result?["name"] as? String {
            // assign Facebook name to PFUser
            user.username = fbUsername
            
            //TODO: assign Facebook image to it
            
            if let userData=result as? [String: AnyObject]{

                let facebookUserId = userData["id"] as! String
                var link = "http://graph.facebook.com/\(facebookUserId)/picture"
                let url = NSURL(string: link)
                var request = NSURLRequest(URL: url!)
                let params = ["height": "200", "width": "200", "type": "square"]
                
                Alamofire.request(.GET, link, parameters: params).response() {
                    (request, response, data, error) in
                    
                    if ( error != nil ) {
                        self.callback(nil,error)
                    }else{
                        var image=UIImage(data:data as! NSData)
                        if var image=image{
                        if image.size.width>280{
                            
                            image=Images.resizeImage(image, width: 280, height: 280)!
                          }
                            
                           
                            var imageData=UIImageJPEGRepresentation(image, 0.8)
                            
                            var filePicture = PFFile(data: imageData)
                           
                            filePicture.saveInBackgroundWithBlock{
                                (success: Bool, error: NSError?) -> Void in
                                if success {
                                   // println("saveImage")
                                }
                                if error != nil {
                                    println(" ParseLogin filePicture error \(error)")
                                }
                            }
                            
                            user[PF_USER_PICTURE]=filePicture
                            // store PFUser after image is saved
                            user.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    // updated username could be stored -> call success
                                    self.callback(user, error)
                                } else {
                                    // updating username failed -> hand error to callback
                                    self.callback(nil, error)
                                }
                            })

  
                        }
                    }
   
                }
                
            }
            
 } else {
            // cannot retrieve username? -> create error and hand it to callback
            let userInfo = [NSLocalizedDescriptionKey : ParseLoginHelper.usernameNotFoundLocalizedDescription]
            let noUsernameError = NSError(
              domain: ParseLoginHelper.errorDomain,
              code: ParseLoginHelper.usernameNotFoundErrorCode,
              userInfo: userInfo
            )
            self.callback(nil, error)
          }
      }
    }
  }
  
}

extension ParseLoginHelper : PFSignUpViewControllerDelegate {
  
  func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
    self.callback(user, nil)
  }
  
}