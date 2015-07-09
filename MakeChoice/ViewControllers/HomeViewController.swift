//
//  HomeViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/9/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate=self
        self.tableView.dataSource=self
        
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

// MARK: tableview delegate and datasource
extension HomeViewController: UITableViewDelegate {
    
}
extension HomeViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell=tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! HomePostTableViewCell
        cell.img1.image=UIImage(named: "Mario")
        cell.img2.image=UIImage(named: "Ninja")
        
        
        cell.img1.backgroundColor=UIColor.redColor()
        cell.img1.layer.cornerRadius=8
        cell.img1.clipsToBounds=true
        
        cell.img2.backgroundColor=UIColor.blueColor()
        cell.img2.layer.cornerRadius=8
        cell.img2.clipsToBounds=true
        
        
        cell.img1.userInteractionEnabled=true
        cell.img1.tag=indexPath.row
        
        cell.img2.userInteractionEnabled=true
        cell.img2.tag=indexPath.row
        
        var img1tapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("img1Tapped:" ))
        cell.img1.addGestureRecognizer(img1tapped)
        
        var img2tapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("img2Tapped:" ))
        cell.img2.addGestureRecognizer(img2tapped)

        
        return cell
    }
    
    func img1Tapped(recognizer:UITapGestureRecognizer ){
        
        println("the \(recognizer.view?.tag)th  posts: img1 tapped")
    }
    
    func img2Tapped(recognizer:UITapGestureRecognizer ){
        
        println("the \(recognizer.view?.tag)th  posts: img2 tapped")
    }


}