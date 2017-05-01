//
//  PostTableViewController.swift
//  tiankeng
//
//  Created by 李源 on 2017/4/3.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit
import os
//import LeanCloud
import AVOSCloud

class PostTableViewController: UITableViewController {

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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    //构建tableview的每一个cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIndentifier = "PostTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as? PostTableViewCell else {
            fatalError("the dequeued cell is not an instance of PostTableViewCell")
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "Arrive":
            guard let arriveViewController = segue.destination as? ArriveTableViewController else {
                fatalError("Unexpeted destination: \(segue.destination)")
            }
            guard let selectedPackageCell = sender as? PostTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedPackageCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedPackage = messages[indexPath.row]
            arriveViewController.message = selectedPackage
            
            arriveViewController.hidesBottomBarWhenPushed = true
            
            break
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    @IBAction func unwindToArriveButton(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ArriveTableViewController, let message = sourceViewController.message {
            
            message.state = "已送达"
            let pk = AVObject(className: "Packages", objectId: message.ID!)
            
            pk.setObject(message.state, forKey: "state")
            
            pk.save()
            
            messages.removeAll()
            loadMessages()
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
        //读取到的数据都是自己接的单
        let currentUser = AVUser.current()
        let currentPhone = currentUser?.mobilePhoneNumber
        query.whereKey("courierPhone", equalTo: currentPhone!)
        query.whereKey("state", equalTo: "已接单")
        //发布的单的数量
        var counts = query.countObjects()
        var allMessages = query.findObjects()
        
        while (counts > 0) {
            let cloudMessage = allMessages?.popLast()
            counts -= 1
            
            let message = self.cloudToLocal(message: cloudMessage! as! AVObject)
            messages.append(message!)
        }
        
        query.whereKey("state", equalTo: "已送达")
        var count1s = query.countObjects()
        var allMessage1s = query.findObjects()
        
        while (count1s > 0) {
            let cloudMessage = allMessage1s?.popLast()
            count1s -= 1
            
            let message = self.cloudToLocal(message: cloudMessage! as! AVObject)
            messages.append(message!)
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
        
        //获得图片
        let file = message.object(forKey: "photo") as? AVFile
        let data = file?.getData()
        let photo = UIImage(data: data!)
        
        let ID = message.objectId!
        let state = message.object(forKey: "state") as! String
        
        let message = Message(package: package, describe: describe, time: time, remark: remark, name: name, phone: phone, address: address, founderPhone: founderPhone, founderAddress: "", courierPhone: courierPhone, courierAddress: "", photo: photo, ID: ID, state: state)
        
        return message
    }
}
