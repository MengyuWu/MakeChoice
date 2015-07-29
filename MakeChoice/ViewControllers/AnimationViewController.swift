//
//  AnimationViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/28/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class AnimationViewController: UIViewController {

    var parseLoginHelper: ParseLoginHelper!
    
    @IBOutlet weak var animationImageView: UIImageView!
    var imageList:[UIImage]=[]
    
    var user:PFUser?
    
    var tabBarInitialViewController:UIViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
        
        for i in 1...16{
            var imageName="win_\(i).png"
            var image=UIImage(named:imageName)
            if let image=image{
            imageList.append(image)
            }
        }
        
        
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            // Initialize the ParseLoginHelper with a callback
            if let error = error {
                // 1
                // ErrorHandling.defaultErrorHandler(error)
                println(error)
            } else  if let user = user {
                // if login was successful, display the TabBarController
                // 2
                self.user=user
                println("login user go to tabbar controller\(user.username)")
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
                
            }
        }
        
        

       
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
 
//        if (self.user != nil){
//            //go to tabbarcontroller
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UIViewController
//            self.presentViewController(tabBarController, animated:true, completion:nil)
//            
//            
//        }
      
        
        animationImageView.animationImages=imageList
        animationImageView.animationRepeatCount=4
        animationImageView.animationDuration=0.5
        animationImageView.startAnimating()
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            println("finished aniamtion")
            
            if self.user == nil{
                let loginViewController = PFLogInViewController()
                loginViewController.fields = .UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten | .Facebook
                loginViewController.delegate = self.parseLoginHelper
                loginViewController.signUpController?.delegate = self.parseLoginHelper
                
                loginViewController.logInView?.logo?.hidden=true
                loginViewController.signUpController?.signUpView?.logo?.hidden=true
                self.presentViewController(loginViewController, animated: true, completion: nil)
            }else{
                 let storyboard = UIStoryboard(name: "Main", bundle: nil)
                 self.tabBarInitialViewController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as? UIViewController
                self.presentViewController(self.tabBarInitialViewController!, animated:true, completion:nil)
            }
            
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

}
