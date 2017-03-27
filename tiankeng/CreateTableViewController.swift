//
//  CreateTableViewController.swift
//  tiankeng
//
//  Created by 李源 on 2017/3/19.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit
import os.log
import LeanCloud
import AVOSCloud

class CreateTableViewController: UITableViewController {
    @IBOutlet weak var saveButton: UIBarButtonItem!

    var message: Message!
    let pk = AVObject(className: "Packages")
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //let section = ["货物详情", "寄货人信息", "送货人信息"]
        let currentUser = LCUser.current
        let founderPhone = currentUser?.mobilePhoneNumber?.stringValue
        
        
        
        message = Message(package: "", describe: "", time: "", remark: "", name: "", phone: "", address: "", founderPhone: founderPhone!, founderAddress: "", courierPhone: "", courierAddress: "", photo: nil, ID: "", state: "")
        
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    //取消按钮
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //货物详情的cell
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PackageCreateTableViewCell", for: indexPath) as! PackageCreateTableViewCell
            cell.packageLabel.text = message?.package
            cell.describeLabel.text = message?.describe
            cell.timeLabel.text = message?.time
            cell.photoImageView.image = message?.photo
            
            return cell
        }
        //寄货人的cell
        else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FounderTableViewCell", for: indexPath) as! FounderTableViewCell
            let currentUser = LCUser.current
            
            
            cell.founderNameLabel.text = currentUser?.username?.stringValue
            cell.FounderPhoneLabel.text = currentUser?.mobilePhoneNumber?.stringValue
            cell.founderAddressLabel.text = currentUser?.get("address")?.stringValue
            //还要加入头像
            
            return cell
        }
        //收货人的cell
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTableViewCell", for: indexPath) as! ReceiverTableViewCell
            
            cell.ReceiverNameLabel.text = message?.name
            cell.ReceiverPhoneLabel.text = message?.phone
            cell.ReceiverAddressLabel.text = message?.address
            
            return cell
        }
        
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


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            os_log("The save button was not pressed, canceiling", log:OSLog.default, type: .debug)
            return
        }
        
        let data = UIImagePNGRepresentation(message.photo!)
        let photo = AVFile.init(data: data!)

        pk.setObject(message.package!, forKey: "package")
        pk.setObject(message.describe!, forKey: "describe")
        pk.setObject(message.time!, forKey: "time")
        pk.setObject(message.remark!, forKey: "remark")
        
        pk.setObject(message.state!, forKey: "state")
        
        pk.setObject(message.name!, forKey: "name")
        pk.setObject(message.phone!, forKey: "phone")
        pk.setObject(message.address!, forKey: "address")
        
        pk.setObject(message.founderPhone, forKey: "founderPhone")
        pk.setObject(photo, forKey: "photo")
        //pk.set("package", value: message.package)
        //pk.set("describe", value: message.describe)
        //pk.set("time", value: message.time)
        //pk.set("remark", value: message.remark)
        //
//        //pk.set("state", value: message.state)
//            
//        pk.set("name", value: message.name)
        //pk.set("phone", value: message.phone)
        //pk.set("address", value: message.address)
            
        //pk.set("founderPhone", value: message.founderPhone)
     //   pk.set("photo", value: photo)
            
        pk.saveInBackground()

    }
    

    @IBAction func unwindToSaveButton(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CreateViewController, let message = sourceViewController.message {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                self.message.package = message.package
                self.message.describe = message.describe
                self.message.time = message.time
                self.message.remark = message.remark
                self.message.photo = message.photo
                
                self.message.state = message.state
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            
            updateSaveButtonState()
        }
    }
    
    @IBAction func unwindToSaveReceiverButton(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CreateReceiverViewController, let message = sourceViewController.message {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                self.message.name = message.name
                self.message.phone = message.phone
                self.message.address = message.address
            
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
        }
        
        updateSaveButtonState()
    }
    
    private func updateSaveButtonState() {
      
        saveButton.isEnabled = (!(message.package?.isEmpty)! && !(message.describe?.isEmpty)! && !(message.time?.isEmpty)! && !(message.remark?.isEmpty)! && !(message.name?.isEmpty)! && !(message.phone?.isEmpty)! && !(message.address?.isEmpty)!)

    }
}
