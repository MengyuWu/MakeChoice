//
//  ReportHelper.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 8/9/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import Foundation
import Parse

class ReportHelper{

    
    static func saveReport(post:Post, reporter: PFUser, description:String, comletionBlock:PFBooleanResultBlock){
        
        var report = PFObject(className: PF_REPORT_CLASS_NAME)
        report[PF_REPORT_POSTID]=post.objectId
        report[PF_REPORT_POSTER]=post.poster
        report[PF_REPORT_REPORTER]=reporter
        report[PF_REPORT_DESCRIPTION]=description

       report.saveInBackgroundWithBlock(comletionBlock)
    }
    
    
    
    
}