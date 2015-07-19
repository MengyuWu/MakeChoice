//
//  DesignHelper.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/11/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import Foundation

class DesignHelper{
    
    // MARK: image background, and conner radius set up
    static func setCircleImage(image:UIImageView){
        
        image.layer.cornerRadius=image.frame.size.width / 2
        image.clipsToBounds=true
    }
    
    static func setImageCornerRadius(image:UIImageView){
        //image.layer.cornerRadius=8
        image.clipsToBounds=true
    }
    
    static func setImageClipsToBounds(image:UIImageView){
        image.clipsToBounds=true
    }
    
    static func showImageHideButton(image:UIImageView, button:UIButton){
        image.alpha=1
        button.alpha=0
    }

    
    static func blankImageShowButton(imageView:UIImageView, button:UIButton){
        imageView.image=UIImage()
        imageView.alpha=0.5
        button.alpha=0.8
    }

    static func imageCorrectRatio(imageView:UIImageView){
        imageView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    static func mergeTwoImages(image1: UIImage , image2: UIImage) -> UIImage {
    
       var img1=Images.resizeImage(image1, width: 300, height: 400)!
       var img2=Images.resizeImage(image2, width: 300, height: 400)!
        
        var size:CGSize=CGSizeMake(img1.size.width+img2.size.width, img1.size.height);
        //UIGraphicsBeginImageContext(size);
        // avoid degradings
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0) // Use this call
        
        img1.drawInRect(CGRectMake(0,0,img1.size.width, img1.size.height))
        img2.drawInRect(CGRectMake(img1.size.width,0,img2.size.width, img2.size.height))
        
        var finalImage=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
  
        finalImage=Images.resizeImage(finalImage, width:90, height:60)!
        return finalImage
    }
}