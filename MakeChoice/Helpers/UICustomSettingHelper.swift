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
}