//
//  UICustomSettingHelper.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/25/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import Foundation
import MBProgressHUD

class UICustomSettingHelper {
    
    static func ZFRippleButtonDefaultSetting(button:ZFRippleButton){
        button.trackTouchLocation=true
        button.shadowRippleEnable=true
        button.rippleBackgroundColor=UIColor(netHex: 0xFEDE45)
        button.rippleColor=UIColor(netHex: 0xCEB438)
    }
    
    static func profileSegmentChanged(selectedItem:UIView, deselectedItem:UIView){
        UIView.animateWithDuration(0.5){
            selectedItem.backgroundColor=UIColor(netHex: 0x486BDA)
            deselectedItem.backgroundColor=UIColor(netHex: 0x98B0E6)
        }
       
        
    }
    
    static func sweetAlertNetworkError(){
        // only show one network error alert
      
        if ( NetworkErrorAlertLock.tryLock()){
            
            println("show network error alert")
            SweetAlert().showAlert("Network Error", subTitle: "Please try later!", style: AlertStyle.Error, buttonTitle: "Ok"){ (isOtherButton) -> Void in
                if isOtherButton == true {
                    println("ok")
                    NetworkErrorAlertLock.unlock()
                }
            }
        }else{
            println("try lock fails")
        }
        
        
        
       
    }
    
    static func MBProgressHUDLoading(view:UIView){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
       // loadingNotification.color=UIColor(red: 0.23, green: 0.50, blue: 0.82, alpha: 0.80)
    }
    
    static func MBProgressHUDProcessingImages(view:UIView){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Processing Images"
        // loadingNotification.color=UIColor(red: 0.23, green: 0.50, blue: 0.82, alpha: 0.80)
    }
    
    static func MBProgressHUDSimple(view:UIView){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        
        // loadingNotification.color=UIColor(red: 0.23, green: 0.50, blue: 0.82, alpha: 0.80)
    }
    
    static func showVoteBars(cell:UITableViewCell, view:UIView){
        
        if let cell=cell as? HomePostTableViewCell{
            // if is voted show the results
            UIView.animateWithDuration(0){
                cell.vote1BarHeightConstraint.constant=0
                cell.vote2BarHeightConstraint.constant=0
                view.layoutIfNeeded()
            }
            
//            cell.vote1BarHeightConstraint.constant=0
//            cell.vote2BarHeightConstraint.constant=0
            
            cell.vote1Bar.alpha=0.8
            cell.vote2Bar.alpha=0.8
            
            // var totalHeight=cell.img1.frame.size.height-70
            var totalHeight=cell.img1.frame.size.height/2
            
            var vote1Percentage=cell.post?.vote1PercentageFloat ?? 0
            var height1:CGFloat=totalHeight*CGFloat(vote1Percentage)
            
            var vote2Percentage=cell.post?.vote2PercentageFloat ?? 0
            var height2:CGFloat=totalHeight*CGFloat(vote2Percentage)
            
            if(cell.post!.votedJustNow){
                UIView.animateWithDuration(2){
                    
                    cell.vote1BarHeightConstraint.constant=height1
                    cell.vote2BarHeightConstraint.constant=height2
                    
                    cell.vote1.alpha=0.9;
                    cell.vote2.alpha=0.9;
                    // changes made in here will be animated
                    view.layoutIfNeeded()
                    cell.post!.votedJustNow=false
                    
                }
            }else{
                cell.vote1BarHeightConstraint.constant=height1
                cell.vote2BarHeightConstraint.constant=height2
                cell.vote1.alpha=0.9;
                cell.vote2.alpha=0.9;
            }
            

            
        }else if let cell=cell as? CategoryDetailTableViewCell{
            
            // if is voted show the results
            UIView.animateWithDuration(0){
                cell.vote1BarHeightConstraint.constant=0
                cell.vote2BarHeightConstraint.constant=0
                view.layoutIfNeeded()
            }
            
//            cell.vote1BarHeightConstraint.constant=0
//            cell.vote2BarHeightConstraint.constant=0
            
            cell.vote1Bar.alpha=0.8
            cell.vote2Bar.alpha=0.8
            
           // var totalHeight=cell.img1.frame.size.height-70
            var totalHeight=cell.img1.frame.size.height/2
            
            var vote1Percentage=cell.post?.vote1PercentageFloat ?? 0
            var height1:CGFloat=totalHeight*CGFloat(vote1Percentage)
            
            var vote2Percentage=cell.post?.vote2PercentageFloat ?? 0
            var height2:CGFloat=totalHeight*CGFloat(vote2Percentage)
            
            if(cell.post!.votedJustNow){
                UIView.animateWithDuration(2){
                    
                    cell.vote1BarHeightConstraint.constant=height1
                    cell.vote2BarHeightConstraint.constant=height2
                    cell.vote1.alpha=0.9;
                    cell.vote2.alpha=0.9;
                    // changes made in here will be animated
                    view.layoutIfNeeded()
                    cell.post!.votedJustNow=false
                    
                }
            }else{
                cell.vote1BarHeightConstraint.constant=height1
                cell.vote2BarHeightConstraint.constant=height2
                cell.vote1.alpha=0.9;
                cell.vote2.alpha=0.9;
            }
            

        }
        
    }
    
}