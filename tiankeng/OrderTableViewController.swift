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
            let pk = LCObject(className: "Packages", objectId: message.ID)
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
 
    private func loadMessages(){
        let query = LCQuery(className: "Packages")
        //读取到的数据都是没有接单的
        query.whereKey("isOrdered", .equalTo("false"))
        
        //满足的未接单的数量
        var counts = query.count().intValue
        //相当于一个保存了所有数据的数组
        var allMessages = query.find().objects!
            while (counts > 0) {
                //逐个读取
                let cloudMessage = allMessages.last
                allMessages.popLast()
                counts -= 1
                
                let message = self.cloudToLocal(message: cloudMessage!)
                
                self.messages.append(message!)
            }
    }
    
    //自己定义一个函数，把leancloud上的LCObject变成我本地的Message形式
    private func cloudToLocal(message: LCObject) -> Message? {
        //狗屎，这个搞了半天
        let package = message.get("package")?.stringValue
        let name = message.get("name")?.stringValue
        let founderPhone = message.get("founderPhone")?.stringValue
        let phone = message.get("phone")?.stringValue
        let address = message.get("address")?.stringValue
        
        let ID = message.objectId
        let state = message.get("state")?.stringValue
        
        let message = Message(package: package!, name: name!, founderPhone: founderPhone!, phone: phone!, address: address!, photo: nil, ID: ID!, state: state!)
        
        return message
    }
}
