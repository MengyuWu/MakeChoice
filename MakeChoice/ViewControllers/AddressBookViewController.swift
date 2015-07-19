//
//  AddressBookViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/18/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit
import AddressBook
import MessageUI
import APAddressBook

class AddressBookViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
 
    var post:Post?{
        didSet{
            println(post?.objectId)
            
        }
    }
    
    var contacts:[APContact]=[]
    let addressBook = APAddressBook()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableview.delegate=self
        tableview.dataSource=self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // load contactinfo
        // Load address book
        self.addressBook.fieldsMask = APContactField.Default | APContactField.Emails
        
        self.addressBook.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true), NSSortDescriptor(key: "lastName", ascending: true)]
        self.addressBook.loadContacts{ (contacts: [AnyObject]!, error: NSError!) -> Void in
            // TODO: Add actiivtyIndicator
            
            self.contacts.removeAll(keepCapacity: false)
            
            if let contacts = contacts as? [APContact] {
                self.contacts=contacts
                // reload the data in case that getting data later than load tableview
                self.tableview.reloadData()
            } else if error != nil {
                // TODO:
                println(error)
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

// MARK: tableivewDataSouce
extension AddressBookViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
      return contacts.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
      var cell = tableView.dequeueReusableCellWithIdentifier("addressBookCell") as! UITableViewCell
      var contact=self.contacts[indexPath.row]
      var firstName=contact.firstName ?? ""
      var lastName=contact.lastName ?? ""
      var username="\(firstName) \(lastName)"
      var email = contact.emails.first as? String
      var phone = contact.phones.first as? String
      cell.textLabel?.text=username
      cell.detailTextLabel?.text = (email != nil) ? email : phone
      cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
      return cell
    }

}

// MARK: tableview Delegate
extension AddressBookViewController:UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var user=self.contacts[indexPath.row]
        shareWithUser(user)
       
    }
    
    func shareWithUser(user: APContact){
        
    let phonesCount = count(user.phones)
        
        if phonesCount > 0 {
            self.sendMSG(user)
        } else {
            println("Contact has no phone number")
        }
        
        
    }
    
    
    func sendMSG(user: APContact){
        if MFMessageComposeViewController.canSendText() {
            
            
            var questions=post?.title ?? ""
            
            //Add attachment as NSData,
            post?.downloadImageSynchronous()
          //  var img1data = UIImagePNGRepresentation(post?.image1.value)
          //  var img2data = UIImagePNGRepresentation(post?.image2.value)
            
            var image1=post?.image1.value
            var image2=post?.image2.value
            var finalImage:UIImage?
            var finalImageData:NSData?
            if let image1=image1, image2=image2 {
             println("merge images")
             finalImage=DesignHelper.mergeTwoImages(image1, image2: image2)
             finalImageData=UIImagePNGRepresentation(finalImage)
                
            }

            
            var messageCompose = MFMessageComposeViewController()
            // TODO: Use primary phone rather than all numbers
            messageCompose.recipients = user.phones as! [String]!
            // body: the msg content, image url
            messageCompose.body = "Help me vote on : \(questions)"
            
            messageCompose.addAttachmentData(finalImageData, typeIdentifier: "kUTTypePNG", filename: "finalimage.png")
          
            messageCompose.messageComposeDelegate = self

            
       
            
            
            self.presentViewController(messageCompose, animated: true, completion: nil)
        } else {
           // ProgressHUD.showError("SMS cannot be sent")
            println("MSG cannot be sent")
        }

    }
    
}


// MARK: MFMessageComposeViewControllerDelegate
extension AddressBookViewController:MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult){
        if result.value == MessageComposeResultSent.value {
            //ProgressHUD.showSuccess("Invitation SMS sent successfully")
            println("Invitation SMS sent successfully")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}