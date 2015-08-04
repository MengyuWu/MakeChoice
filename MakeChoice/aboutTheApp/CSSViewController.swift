//
//  CSSViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 8/3/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit

class CSSViewController: UIViewController {
    
    var webView: UIWebView! {
        didSet {
            if let filename = self.filename {
                self.updateUIWithCSSFile(filename)
            }
        }
    }
    
    var filename: String? {
        didSet {
            if let filename = self.filename {
                if self.webView != nil {
                    self.updateUIWithCSSFile(filename)
                }
            }
        }
    }


    func updateUIWithCSSFile(filename: String)
    {
        let path = NSBundle.mainBundle().pathForResource(filename, ofType: "css")!
        let data = NSData(contentsOfFile: path)!
        let string = NSString(data: data, encoding: NSASCIIStringEncoding) as! String
        self.webView.loadHTMLString(string, baseURL: NSURL(string: "")!)
        self.webView.backgroundColor = UIColor.blackColor()
       // self.webView.delegate = self
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView = UIWebView(frame: self.view.frame)
        self.view.addSubview(self.webView)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "donePressed")

    }
    
    func donePressed()
    {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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

extension CSSViewController: UIWebViewDelegate
{
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        return false
    }
}

