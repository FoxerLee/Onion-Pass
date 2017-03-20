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
    @IBOutlet weak var packageNameTextField: UITextField!
    @IBOutlet weak var describeTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var remarkTextField: UITextField!


    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var message: Message?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        packageNameTextField.delegate = self
        describeTextField.delegate = self
        timeTextField.delegate = self
        remarkTextField.delegate = self
        
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
        packageNameTextField.resignFirstResponder()
        describeTextField.resignFirstResponder()
        timeTextField.resignFirstResponder()
        remarkTextField.resignFirstResponder()
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
//    @IBAction func cancel(_ sender: UIBarButtonItem) {
//        dismiss(animated: true, completion: nil)
//    }
    
    //Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //只有当按下Save后才配置转换后的view
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            os_log("The save button was not pressed, canceiling", log:OSLog.default, type: .debug)
            
            return
        }
        
        let package = packageNameTextField.text ?? ""
        let describe = describeTextField.text ?? ""
        let time = timeTextField.text ?? ""
        let remark = remarkTextField.text ?? ""
        let photo = photoImageView.image
        
        
        
        //在这里把数据上传到云端
        let pk = LCObject(className: "Packages")
        pk.set("package", value: package)
        pk.set("describe", value: describe)
        pk.set("time", value: time)
        pk.set("remark", value: remark)
   //     pk.set("photo", value: photo as! LCValueConvertible?)
        
        //这个是判定该货物是否被接单
        let state = "未接单"
        pk.set("state", value: state)
        
        //将当前用户的手机号上传上去
        let currentUser = LCUser.current!
        let founderPhone = currentUser.mobilePhoneNumber?.stringValue
        let founderAddress = pk.get("address")?.stringValue
        pk.set("founderPhone", value: founderPhone)
        
        pk.save()
        //把唯一对应的id保存起来
        let ID = pk.objectId
        //同时把数据保存到本地
        self.message = Message(package: package, describe: describe, time: time, remark: remark, name: "", phone: "", address: "", founderPhone: founderPhone!, founderAddress: founderAddress!, courierPhone: "", courierAddress: "", photo: photo, ID: ID!, state: state)
    }
    
    //Private Methods
    private func updateSaveButtonState(){
        //text field为空的时候Save按钮无效
        let packageNameText = packageNameTextField.text ?? ""
        let describeText = describeTextField.text ?? ""
        let timeText = timeTextField.text ?? ""
        let remarkText = remarkTextField.text ?? ""
        
        saveButton.isEnabled = (!packageNameText.isEmpty && !describeText.isEmpty && !timeText.isEmpty && !remarkText.isEmpty)
    }
}
