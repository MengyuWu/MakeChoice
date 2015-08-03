//
//  AppDelegate.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/8/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ParseFacebookUtilsV4
import MaveSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var parseLoginHelper: ParseLoginHelper!
   static var startViewController: AnimationViewController?
    
    /*Launcing tips alert*/
    static var isLaunching=false
    static var dontShowAgain=false
    
    override init() {
        super.init()
        
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            // Initialize the ParseLoginHelper with a callback
            if let error = error {
                // 1
                println("AppDelegate: \(error)")
            } else  if let user = user {
                // if login was successful, display the TabBarController
                // 2
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UIViewController
                // 3
                self.window?.rootViewController!.presentViewController(tabBarController, animated:true, completion:nil)
            }
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Parse.setApplicationId("woPlKhj8Dt6WVfev3I62IZ2ZFvlWPZUbbJg0o8rT", clientKey: "PVlVNH5HoD73mxJ97dcCQqPp7VlLNWCMLkd1DIiB")
 
        
        
        // Register for Push Notitications, if running iOS 8
        if application.respondsToSelector("registerUserNotificationSettings:") {
            
            let types:UIUserNotificationType = (.Alert | .Badge | .Sound)
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
        } else {
            // Register for Push Notifications before iOS 8
            application.registerForRemoteNotificationTypes(.Alert | .Badge | .Sound)
        }
        
        // MARK: LOGIN
        
        // Initialize Facebook
        // 1
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        // check if we have logged in user
        // 2
        let user = PFUser.currentUser()
        
       
        
        if (user != nil) {
            // 3
            // if we have a user, set the TabBarController to be the initial View Controller
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            startViewController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
            
            // whether it logged in or not, both go to animationViewController
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            AppDelegate.startViewController = storyboard.instantiateViewControllerWithIdentifier("AnimationViewController") as?
            AnimationViewController
            AppDelegate.startViewController!.user=user
            
            
            
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            AppDelegate.startViewController = storyboard.instantiateViewControllerWithIdentifier("AnimationViewController") as?
            AnimationViewController
            

        }
        
        // 5
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = AppDelegate.startViewController;
        self.window?.makeKeyAndVisible()
        
        
        
        // MARK:MAVE INVITE FRIEND PAGE
        MaveSDK.setupSharedInstanceWithApplicationID(MAVE_SDK_APPLICATION_ID)
        
        //return true
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
       
        // facebook integartion
        FBSDKAppEvents.activateApp()
     
        // TODO: Be careful, may have bugs
       if var controller=self.window?.rootViewController as? UITabBarController{
          if let user=PFUser.currentUser(){
            println("\(user.username) has logged in")
           ParseHelper.updateProfileTabBadgeValue(controller)
          }else{
            println("user is not login")
        }
       
       }

        
    }

    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
     // MARK:Notification
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        println("didRegisterForRemoteNotificationsWithDeviceToken")
        
        let currentInstallation = PFInstallation.currentInstallation()
        
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackgroundWithBlock { (succeeded, e) -> Void in
  
        }
    }
    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("failed to register for remote notifications:  (error)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println("didReceiveRemoteNotification")
        PFPush.handlePush(userInfo)
        //println("userInfo:\(userInfo)")
        
        
        if var controller=self.window?.rootViewController as? UITabBarController{
            println("update badge value 1")
          //  ParseHelper.updateProfileTabBadgeValue(controller)
        }else if var controller=AppDelegate.startViewController?.tabBarInitialViewController as? UITabBarController{
            println("update badge value 2")
            ParseHelper.updateProfileTabBadgeValue(controller)
            
           
            
//            SweetAlert().showAlert("Notification", subTitle: "You have a new notification!", style: AlertStyle.Warning, buttonTitle:"Ok", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "Show", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
//                if isOtherButton == true {
//                    
//                    print("ok Button  Pressed", appendNewline: false)
//                }
//                else {
//                    controller.selectedIndex=3
//  
//                }
//            }
            
           
            
        }

        
        //broadcasting
        NSNotificationCenter.defaultCenter().postNotificationName("Received Notification", object: self)
     }

}

