//
//  RegisterViewController.swift
//  tiankeng
//
//  Created by 李源 on 2017/3/6.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit
//import LeanCloud
import AVOSCloud
import os

class RegisterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = iconImageView.frame.size.width / 2
        // Do any additional setup after loading the view.
        
        iconImageView.layer.cornerRadius = 10.0
        iconImageView.layer.borderWidth = 5.0
        iconImageView.layer.borderColor = UIColor.white.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Register(_ sender: UIButton) {
        //let registerUser = LCUser()
        let registerUser = AVUser()
        
        let userNameText = nameTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        let phoneText = phoneTextField.text ?? ""
        
        //确保要全部输入
        if(!userNameText.isEmpty && !passwordText.isEmpty && !phoneText.isEmpty) {
            //将用户的用户名和密码放入数据库
            
            registerUser.username = userNameText
            registerUser.password = passwordText
            registerUser.mobilePhoneNumber = phoneText
            let data = UIImagePNGRepresentation(iconImageView.image!)
            let photo = AVFile.init(data: data!)
            
            registerUser.setObject(photo, forKey: "icon")
            
            
            registerUser.signUpInBackground({ (Bool, Error) in
                if(Bool) {
                    //切换回登陆界面
                    let sb = UIStoryboard(name: "Main", bundle:nil)
                    let vc = sb.instantiateViewController(withIdentifier: "LVC") as! ViewController
                    
                    self.present(vc, animated: true, completion: nil)
                }
                
                else {
                    let alert = UIAlertController(title: "用户名或手机号已经被注册", message: nil, preferredStyle: .alert)
                    let action = UIAlertAction(title: "请重新输入", style: .default, handler: nil)
                    
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            })
            
        }
        //如果没有输入完
        else{
            let alert = UIAlertController(title: "输入信息不完整", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "请确认输入完全", style: .default, handler: nil)
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }

    }
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        iconImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    //cancel按钮
    @IBAction func cancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}
