//
//  DetailTableViewController.swift
//  tiankeng
//
//  Created by 李源 on 2017/3/31.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit
import LeanCloud

class DetailTableViewController: UITableViewController {

    var message: Message!
    
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
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PackageDetailTableViewCell", for: indexPath) as! PackageDetailTableViewCell
            cell.packageLabel.text = message.package
            cell.stateLabel.text = message.state
            cell.timeLabel.text = message.time
            cell.photoImageView.image = message.photo
            
            return cell
        }
        
        else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostmanDetailTableViewCell", for: indexPath) as! PostmanDetailTableViewCell
            //如果没有接单的话
            if (message.state == "未接单") {
                cell.PostmanNameLabel.text = ""
                cell.PostmanPhoneLabel.text = ""
            }
            else {
                //利用手机号找到名字
                let query = LCQuery(className: "_User")
                let postmanPhone = message.courierPhone!
                query.whereKey("mobilePhoneNumber", .equalTo(postmanPhone))
                var object = query.find().objects
                let postman = object?.popLast()
                
                cell.PostmanPhoneLabel.text = postmanPhone
                cell.PostmanNameLabel.text = postman?.get("username")?.stringValue
                
            }
            return cell
        }
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverDetailTableViewCell", for: indexPath) as! ReceiverDetailTableViewCell
            
            cell.ReceiverNameLabel.text = message.name
            cell.ReceiverPhoneLabel.text = message.phone
            cell.ReceiverAddressLabel.text = message.address
            
            return cell
        }

    }
 
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "货物信息"
        }
            
        else if (section == 1) {
            return "送货人信息"
        }
            
        else {
            return "收货人信息"
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
