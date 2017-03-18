//
//  CreateViewController.swift
//  tiankeng
//
//  Created by 李源 on 2017/2/8.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit
import os.log
import LeanCloud

class CreateViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    //MARK:Properties
    @IBOutlet weak var packageTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!

    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var message: Message?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        packageTextField.delegate = self
        nameTextField.delegate = self
        phoneTextField.delegate = self
        addressTextField.delegate = self
        
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func Savedata(_ sender: UIBarButtonItem) {
        
    }

    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField){
        //Save按钮在编辑的时候无效
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //确保输入了必要的信息
        updateSaveButtonState()
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //dismiss the picker if user canceled
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        photoImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func hideKeyboard() {
        packageTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        packageTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
    }
    
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        hideKeyboard()
        let imagePickerController = UIImagePickerController()
        //只允许照片被选择
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    //取消按钮的相关
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //只有当按下Save后才配置转换后的view
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            os_log("The save button was not pressed, canceiling", log:OSLog.default, type: .debug)
            
            return
        }
        
        let package = packageTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let address = addressTextField.text ?? ""
        let photo = photoImageView.image
        
        
        
        //在这里把数据上传到云端
        let pk = LCObject(className: "Packages")
        pk.set("package", value: package)
        pk.set("name", value: name)
        pk.set("phone", value: phone)
        pk.set("address", value: address)
   //     pk.set("photo", value: photo as! LCValueConvertible?)
        
        //这个是判定该货物是否被接单
        let isOrdered = "false"
        pk.set("isOrdered", value: isOrdered)
        
        //将当前用户的手机号上传上去
        let currentUser = LCUser.current!
        let founderPhone = currentUser.mobilePhoneNumber?.stringValue
        pk.set("founderPhone", value: founderPhone)
        
        pk.save()
        //把唯一对应的id保存起来
        let ID = pk.objectId
        //同时把数据保存到本地
        self.message = Message(package: package, name: name, founderPhone: founderPhone!, phone: phone, address: address, photo: photo, ID: ID!, isOrdered: isOrdered)
    }
    
    //Private Methods
    private func updateSaveButtonState(){
        //text field为空的时候Save按钮无效
        let packageText = packageTextField.text ?? ""
        let phoneText = phoneTextField.text ?? ""
        let nameText = nameTextField.text ?? ""
        let addressText = addressTextField.text ?? ""
        
        saveButton.isEnabled = (!packageText.isEmpty && !phoneText.isEmpty && !nameText.isEmpty && !addressText.isEmpty)
    }
}
