//
//  PostViewController.swift
//  MakeChoice
//
//  Created by 吴梦宇 on 7/8/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit

class PostViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var imagePickerController = UIImagePickerController()
    
    var imgAddButton:Int=0
    
    @IBOutlet weak var img1: UIImageView!
    
    @IBOutlet weak var img2: UIImageView!
    @IBAction func addImg1ButtonPressed(sender: AnyObject) {
        imgAddButton=1;
        self.showPhotoSourceSelection()
    }

    @IBAction func addImg2ButtonPressed(sender: AnyObject) {
        imgAddButton=2;
        self.showPhotoSourceSelection()
    }
    
    
    func showPhotoSourceSelection() {
        let alertController = UIAlertController(title: nil, message: "where do you want to get your picture from?", preferredStyle: .ActionSheet)
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if (UIImagePickerController.isCameraDeviceAvailable(.Rear)){
            let cameraAction = UIAlertAction(title: "Photo from Camera", style: .Default){ (action) in
                self.showImagePickerController(.Camera)
            }
            
            alertController.addAction(cameraAction)
        }
        
        let photoLibrayAction = UIAlertAction(title: "Photo from Libray", style: .Default){ (action) in
            self.showImagePickerController(.PhotoLibrary)
        }
        
        alertController.addAction(photoLibrayAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType){
        
        // display a photo taking overlay - or will show the users photo library.
        //        case PhotoLibrary
        //        case Camera
        //        case SavedPhotosAlbum
        
        //create a controller in code
        //imagePickerController=UIImagePickerController()
        
        imagePickerController.sourceType=sourceType
        imagePickerController.delegate=self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePickerController.delegate = self
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

// MARK: delegate
extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        // replace the img1 place holder
        if(self.imgAddButton==1){
             self.img1.image=image
        }else if(self.imgAddButton==2){
            self.img2.image=image
        }
       
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
