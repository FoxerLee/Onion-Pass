//
//  AddressTableViewController.swift
//  tiankeng
//
//  Created by 李源 on 2017/4/8.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit
import os.log
class AddressTableViewController: UITableViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addressTextField: UITextField!
    var address: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "我的地址"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "洋葱骑士将从这里获取你寄出的物品"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //只有当按下Save后才配置转换后的view
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            os_log("The save button was not pressed, canceiling", log:OSLog.default, type: .debug)
            
            return
        }
        
        address = addressTextField.text ?? ""
    }
}
