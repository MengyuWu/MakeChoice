//
//  UICustomSettingHelper.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/25/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import Foundation

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
    
}