//
//  SettingTableViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 8/3/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit
import MBProgressHUD

class SettingTableViewController: UITableViewController {
    
    struct IndexPaths {
      
        static let Acknowledgements = NSIndexPath(forRow: 0, inSection: 0)
        static let TermsOfService = NSIndexPath(forRow: 1, inSection: 0)
        static let PrivacyPolicy = NSIndexPath(forRow: 2, inSection: 0)
        static let ContactUs = NSIndexPath(forRow: 3, inSection: 0)
       
    }

    func acknowledgements()
    {
       // SwiftSpinner.show("Loading...", animated: true)
        let vc = CSSViewController()
        vc.filename = "Acknowledgements"
        vc.title = "Acknowledgements"
        let navVC = UINavigationController(rootViewController: vc)
        self.presentViewController(navVC, animated: true) {
           // SwiftSpinner.hide()
        }
    }
    
    func termsOfService()
    {
       // SwiftSpinner.show("Loading...", animated: true)
        let vc = CSSViewController()
        vc.filename = "TermsOfService"
        vc.title = "Terms of Service"
        let navVC = UINavigationController(rootViewController: vc)
        self.presentViewController(navVC, animated: true) {
          //  SwiftSpinner.hide()
        }
    }
    
    func privacyPolicy()
    {
       // SwiftSpinner.show("Loading...", animated: true)
        let vc = CSSViewController()
        vc.filename = "PrivacyPolicy"
        vc.title = "Privacy Policy"
        let navVC = UINavigationController(rootViewController: vc)
        self.presentViewController(navVC, animated: true) {
           // SwiftSpinner.hide()
        }
    }

    func contactUs()
    {
        if MFMailComposeViewController.canSendMail() {
            UICustomSettingHelper.MBProgressHUDSimple(self.view)
            
            let mailer = MFMailComposeViewController()
            mailer.mailComposeDelegate = self
            mailer.setSubject("Contact Us／Report")
            mailer.setToRecipients([ADMIN_EMAIL])
            mailer.setMessageBody("Enter message here...", isHTML: false)
            self.presentViewController(mailer, animated: true) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
        }else{
            SweetAlert().showAlert("Could Not Send Email!", subTitle: "Your device could not send e-mail.  Please check e-mail configuration and try again!", style: AlertStyle.Warning)
        }
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 4
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingTableViewController: UITableViewDelegate
{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath {
        case IndexPaths.Acknowledgements:
            self.acknowledgements()
        case IndexPaths.TermsOfService:
            self.termsOfService()
        case IndexPaths.PrivacyPolicy:
            self.privacyPolicy()
        case IndexPaths.ContactUs:
            self.contactUs()

  
        default:
            println("do nothing")
        }
    }
}

extension SettingTableViewController: MFMailComposeViewControllerDelegate
{
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!)
    {
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
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}