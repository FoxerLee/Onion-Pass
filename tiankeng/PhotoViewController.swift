//
//  PhotoViewController.swift
//  tiankeng
//
//  Created by 李源 on 2017/4/8.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit
import os.log
import AVOSCloud

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    var iconImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser = AVUser.current()
        let file = currentUser?.object(forKey: "icon") as! AVFile
        let data = file.getData()
        let photo = UIImage(data: data!)
        
        iconImageView.image = photo
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        iconImageView.image = selectedImage
        iconImage = iconImageView.image
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)

    }
    
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        super.prepare(for: segue, sender: sender)
//        guard let button = sender as? UIBarButtonItem, button === saveButton else{
//            os_log("The save button was not pressed, canceiling", log:OSLog.default, type: .debug)
//            
//            return
//        }·
//        iconImage = iconImageView.image
//        
//        let data = UIImagePNGRepresentation(self.iconImage!)
//        let photo = AVFile.init(data: data!)
//        
//        let currentUser = AVUser.current()
//        currentUser?.setValue(photo, forKey: "icon")
//        currentUser?.save()
//    }
}
