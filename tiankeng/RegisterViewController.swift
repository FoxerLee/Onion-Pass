//
//  RegisterViewController.swift
//  tiankeng
//
//  Created by 李源 on 2017/3/6.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit
import LeanCloud
import os

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Register(_ sender: UIButton) {
        let registerUser = LCUser()
        
        let userNameText = nameTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        let phoneText = phoneTextField.text ?? ""
        
        //确保要全部输入
        if(!userNameText.isEmpty && !passwordText.isEmpty && !phoneText.isEmpty) {
            //将用户的用户名和密码放入数据库
            registerUser.username = LCString(userNameText)
            registerUser.password = LCString(passwordText)
            registerUser.mobilePhoneNumber = LCString(phoneText)
            
            registerUser.signUp()
            
            //切换回登陆界面
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "LVC") as! ViewController
            
            self.present(vc, animated: true, completion: nil)
        }
        //如果没有输入完
        else{
            let alert = UIAlertController(title: "输入信息不完整", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "请确认输入完全", style: .default, handler: nil)
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }

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
