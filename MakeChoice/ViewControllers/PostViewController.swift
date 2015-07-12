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
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var img1: UIImageView!
    
    @IBOutlet weak var img2: UIImageView!
    
    @IBOutlet weak var addImg1Button: UIButton!
    
    @IBOutlet weak var addImg2Button: UIButton!
    
    @IBAction func addImg1ButtonPressed(sender: AnyObject) {
        imgAddButton=1;
        self.showPhotoSourceSelection()
    }

    @IBAction func addImg2ButtonPressed(sender: AnyObject) {
        imgAddButton=2;
        self.showPhotoSourceSelection()
    }
    
    
    @IBAction func PostPressed(sender: AnyObject) {
        println("post pressed")
        
        // Note: before post, must check title, image1, image2 is posted
        
        var post=Post()
        post.image1.value=img1.image
        post.image2.value=img2.image
        post.isPrivate=false //add action on it
        post.title=titleTextField.text // should not let it upload if no title?
        
        //Can't check image is nil
//        if (img1.image != nil && img2.image != nil ){
//         println("upload")
//         post.uploadPost()
//        }
      
        var img1Data=UIImageJPEGRepresentation(img1.image, 0.8)
        var img2Data=UIImageJPEGRepresentation(img2.image, 0.8)
        if (img1Data != nil && img2Data != nil ){
            println("upload")
            post.uploadPost()
         }
        
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
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("viewwiLLaPPEAR: \(imgAddButton)")
        DesignHelper.setImageCornerRadius(self.img1)
        DesignHelper.setImageCornerRadius(self.img2)
        if(self.imgAddButton==0){
        DesignHelper.blankImageShowButton(img1, button: addImg1Button)
        DesignHelper.blankImageShowButton(img2, button: addImg2Button)
        }else{
            // some pictures is choosen
            self.imgAddButton=0
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

// MARK: delegate
extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        // replace the img1 place holder
        if(self.imgAddButton==1){
            self.img1.image=image
            DesignHelper.showImageHideButton(img1, button: addImg1Button)
           
        }else if(self.imgAddButton==2){
            self.img2.image=image
            DesignHelper.showImageHideButton(img2, button: addImg2Button)
      
        }
    
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


