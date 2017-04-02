//
//  ViewController.swift
//  tiankeng
//
//  Created by 李源 on 2017/2/4.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit
import LeanCloud
import AVOSCloud

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var myImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myImageView.layer.masksToBounds = true
        myImageView.layer.cornerRadius = myImageView.frame.size.width / 2
        
        
        
       // phoneTextField.leftViewMode = UITextFieldViewMode.always
       // phoneTextField.leftView = UIImageView(image:UIImage(named: "User"))
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(_ sender: AnyObject) {
        
        let phoneText = phoneTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        
        //用手机号登陆
        LCUser.logIn(mobilePhoneNumber: phoneText, password: passwordText) { result in
            switch result {
            case .success( _):
                //切换登陆界面
                let sb = UIStoryboard(name: "Main", bundle:nil)
                //CVC为该界面storyboardID，Main.storyboard中选中该界面View，Identifier inspector中修改
                let vc = sb.instantiateViewController(withIdentifier: "MTBC") as! MainTabBarController
                self.present(vc, animated: true, completion: nil)
                
                break
            case .failure( _):
                self.phoneTextField.text = nil
                self.passwordTextField.text = nil
                
                let alert = UIAlertController(title: "手机号或密码错误", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "请重新输入", style: .default, handler: nil)
                
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                break
            }
        }

    }
    
    //实现按return和背景键之后能够关掉键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}

