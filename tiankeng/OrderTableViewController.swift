//
//  OrderTableViewController.swift
//  tiankeng
//
//  Created by 李源 on 2017/3/8.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit
import os
import LeanCloud
import AVOSCloud

class OrderTableViewController: UITableViewController {

    var messages = [Message]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(OrderTableViewController.reload), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "reloading")
        self.refreshControl = refreshControl
        loadMessages()
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
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    //构建tableview的每一个cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIndentifier = "OrderTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as? OrderTableViewCell else {
            fatalError("the dequeued cell is not an instance of OrderTableViewCell")
        }

        //这里是先讲package的信息从一个存这些数据的数组中读取出来
        let message = messages[indexPath.row]
        
        //然后一个一个把信息写到cell的对应的label或者image中
        cell.nameLabel.text = message.name
        cell.packageLabel.text = message.package
        cell.phoneLabel.text = message.phone
        cell.photoImageView.image = message.photo
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    @IBAction func unwindToConfirmButton(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ConfirmViewController, let message = sourceViewController.message {
            message.state = "已接单"
            let pk = LCObject(className: "Packages", objectId: message.ID!)
            pk.set("state", value: message.state)
            pk.save()
            
            messages.removeAll()
            loadMessages()
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "Confirm":
            guard let confirmViewController = segue.destination as? ConfirmViewController else {
                fatalError("Unexpeted destination: \(segue.destination)")
            }
            guard let selectedPackageCell = sender as? OrderTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedPackageCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedPackage = messages[indexPath.row]
            confirmViewController.message = selectedPackage
            
            confirmViewController.hidesBottomBarWhenPushed = true
            
            break
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    func reload() {
        messages.removeAll()
        loadMessages()
        
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
 
    private func loadMessages() {
        let query = AVQuery(className: "Packages")
        //读取到的数据都是没有接单的
        query.whereKey("state", equalTo: "未接单")
        //发布的单的数量
        var counts = query.countObjects()
        var allMessages = query.findObjects()
        
        while (counts > 0) {
            let cloudMessage = allMessages?.popLast()
            counts -= 1
            
            let message = self.cloudToLocal(message: cloudMessage! as! AVObject)
            let currentUser = LCUser.current
            let founderPhone = currentUser?.mobilePhoneNumber?.stringValue
            if ( message?.founderPhone == founderPhone) {
                messages.append(message!)
            }
            
        }
        
    }
    
    //自己定义一个函数，把leancloud上的LCObject变成我本地的Message形式
    private func cloudToLocal(message: AVObject) -> Message? {
        let package = message.object(forKey: "package") as! String
        let describe = message.object(forKey: "describe") as! String
        let time = message.object(forKey: "time") as! String
        let remark = message.object(forKey: "remark") as! String
        
        let name = message.object(forKey: "name") as! String
        let phone = message.object(forKey: "phone") as! String
        let address = message.object(forKey: "address") as! String
        
        let founderPhone = message.object(forKey: "founderPhone") as! String
        
        let courierPhone = message.object(forKey: "courierPhone") as? String
        
        let ID = message.objectId!
        let state = message.object(forKey: "state") as! String
        
        let message = Message(package: package, describe: describe, time: time, remark: remark, name: name, phone: phone, address: address, founderPhone: founderPhone, founderAddress: "", courierPhone: courierPhone, courierAddress: "", photo: nil, ID: ID, state: state)
        
        return message
    }
    
}

