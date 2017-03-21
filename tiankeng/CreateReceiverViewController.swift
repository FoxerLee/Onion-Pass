//
//  CreateReceiverViewController.swift
//  tiankeng
//
//  Created by 李源 on 2017/3/20.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit
import os.log
import LeanCloud

class CreateReceiverViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var ReceiverNameTextField: UITextField!
    @IBOutlet weak var ReceiverPhoneTextField: UITextField!
    @IBOutlet weak var ReceiverAddressTextField: UITextField!
    @IBOutlet weak var SaveButton: UIBarButtonItem!

    var message: Message!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ReceiverNameTextField.delegate = self
        self.ReceiverPhoneTextField.delegate = self
        self.ReceiverAddressTextField.delegate = self
        
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        //Save按钮在编辑的时候无效
        SaveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //确保输入了必要的信息
        updateSaveButtonState()
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //只有当按下Save后才配置转换后的view
        guard let button = sender as? UIBarButtonItem, button === SaveButton else{
            os_log("The save button was not pressed, canceiling", log:OSLog.default, type: .debug)
            return
        }
        let receiverName = ReceiverNameTextField.text
        let receiverPhone = ReceiverPhoneTextField.text
        let receiverAddress = ReceiverAddressTextField.text
        
        self.message = Message(package: "", describe: "", time: "", remark: "", name: receiverName!, phone: receiverPhone!, address: receiverAddress!, founderPhone: "", founderAddress: "", courierPhone: "", courierAddress: "", photo: nil, ID: "", state: "")
        
        
    }
    
    
    //Private Methods
    private func updateSaveButtonState(){
        //text field为空的时候Save按钮无效
        let ReceiverNameText = ReceiverNameTextField.text ?? ""
        let ReceiverPhoneText = ReceiverPhoneTextField.text ?? ""
        let ReceiverAddressText = ReceiverAddressTextField.text ?? ""
       
        
        SaveButton.isEnabled = (!ReceiverNameText.isEmpty && !ReceiverPhoneText.isEmpty && !ReceiverAddressText.isEmpty)
    }
}
