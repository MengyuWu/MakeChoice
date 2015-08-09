//
//  ReportViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 8/9/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit
import MessageUI

class ReportViewController: UIViewController {
    
    var post:Post?

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textView.delegate=self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
    
        var description=textView.text
        
        if(description==""){
           SweetAlert().showAlert("Missing description!", subTitle: "Please describe the inappropriate content!", style: AlertStyle.Warning)

        }else{
            
            if let post=self.post{

                ReportHelper.saveReport(post, reporter: PFUser.currentUser()!, description: description){
                    (success:Bool, error:NSError?) -> Void in
                    
                    if success {
                        //TODO: send email to administrator
                        
                        
                        // ProcessHUD, pop up
                       SweetAlert().showAlert("Submitted!", subTitle: "", style: AlertStyle.Success)
                   
                     //   self.navigationController?.popViewControllerAnimated(true)
                        
                        
                       
                        // Require mail setting in the phone
                        
                        if MFMailComposeViewController.canSendMail(){
                            var reporter=PFUser.currentUser()?.username ?? ""
                            var postId=post.objectId!
                            var poster=post[PF_POST_POSTER]?.username ?? ""
                            
                            var info="\(reporter) reported a spam, postId:\(postId) , poster: \(poster), description:\(description))"
                            let mailer = MFMailComposeViewController()
                            mailer.mailComposeDelegate=self
                            mailer.setSubject("Report Spam")
                            mailer.setToRecipients([ADMIN_EMAIL])
                            mailer.setMessageBody(info, isHTML: false)
                           self.presentViewController(mailer, animated: true, completion: nil)
                            
                        }
                        
                    }
                    
                    if (error != nil){
                        
                        SweetAlert().showAlert("Error!", subTitle: "Network Error", style: AlertStyle.Error)
                        
                    }
                    
                }
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

// MARK:UItextview delegate
extension ReportViewController:UITextViewDelegate{
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return (count(textView.text) + (count(text) - range.length) <= 400)
    }
    func textViewDidEndEditing(textView: UITextView) {
       println("DidEndEditing")
        textView.resignFirstResponder()
    }
}

extension ReportViewController:MFMailComposeViewControllerDelegate{
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        switch result.value {
        case MFMailComposeResultCancelled.value:
            println("Mail cancelled")
        case MFMailComposeResultSaved.value:
            println("Mail saved")
        case MFMailComposeResultSent.value:
            println("Mail sent")
        case MFMailComposeResultFailed.value:
            println("Mail sent failure: \(error.localizedDescription)")
        default:
            break
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}