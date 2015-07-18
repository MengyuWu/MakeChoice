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

extension AddressBookViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
      return contacts.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
      var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
      cell.textLabel?.text="mengyu"
      return cell
    }

}

extension AddressBookViewController:UITableViewDelegate{
    
}
