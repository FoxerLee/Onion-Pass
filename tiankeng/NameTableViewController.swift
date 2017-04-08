//
//  NameTableViewController.swift
//  tiankeng
//
//  Created by 李源 on 2017/4/8.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit
import os.log

class NameTableViewController: UITableViewController {

    
    var nickName: String?
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    @IBOutlet weak var nickNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "我的昵称"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "其他人会看见你的这个名字"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //只有当按下Save后才配置转换后的view
        guard let button = sender as? UIBarButtonItem, button === SaveButton else{
            os_log("The save button was not pressed, canceiling", log:OSLog.default, type: .debug)
            
            return
        }
        
        nickName = nickNameTextField.text ?? ""
    }

}
