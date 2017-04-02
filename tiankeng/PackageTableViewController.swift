//
//  PackageTableViewController.swift
//  tiankeng
//
//  Created by 李源 on 2017/2/13.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit
import os.log
import LeanCloud
import AVOSCloud

class PackageTableViewController: UITableViewController {

    var messages = [Message]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.editButtonItem.title = "确认送达"
        
        //刷新
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PackageTableViewController.reload), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "reloading")
        self.refreshControl = refreshControl
        loadMessages()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    //有多少种类的cell
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    //总共有多少行cell
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    //被显示的cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //使用我自己定义的cell
        let cellIdentifier = "PackageTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PackageTableViewCell else{
            fatalError("the dequeued cell is not an instance of PackageTableViewCell")
        }
        
        let message = messages[indexPath.row]
        
        cell.packageLabel.text = message.package
        cell.nameLabel.text = message.name
        cell.stateLabel.text = message.state
        cell.photoImageView.image = message.photo
        
        return cell
    }

    //支持编辑和删除，之后连到数据库就在里面更新
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath:IndexPath) {
        if editingStyle == .delete {
            //这里之后要在数据库里面也删除这些东西（搞定了），还有另一个界面的更新
            let message = messages[indexPath.row]
            let query = LCQuery(className: "Packages")
            
            
            //在leancloud中删除数据
            query.whereKey("objectId", .equalTo(message.ID!))
            query.find { result in
                switch result {
                case .success(let objects):
                    let m = objects.first
                    m?.delete()
                    break
                case .failure(let error):
                    print(error)
                }
            }
            
            
            messages.remove(at: indexPath.row)
            
//            //删除后保存数据
//            saveMessages()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert {
            
        }
    }
    
    //更改左键的title，左键用的自带的edit
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if self.isEditing {
            self.editButtonItem.title = "返回"
        }
        else {
            self.editButtonItem.title = "确认送达"
        }
    }
    
    //prepare两个不同的界面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "AddItem":
            os_log("adding a new package", log: OSLog.default, type: .default)
            
            break
        //加载显示详情的viewcontroller
        case "ShowDetail":
            guard let MessageDetailViewController = segue.destination as? DetailTableViewController else {
                fatalError("Unexpeted destination: \(segue.destination)")
            }
            
            guard let selectedPackageCell = sender as? PackageTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedPackageCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedPackage = messages[indexPath.row]
            MessageDetailViewController.message = selectedPackage
            //隐藏下面的tab bar
            MessageDetailViewController.hidesBottomBarWhenPushed = true
            break
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    //添加新的一个cell
    @IBAction func unwindToPackageMessage(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? CreateTableViewController, let message = sourceViewController.message {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                //加载已经存在的
                messages[selectedIndexPath.row] = message
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                // 添加一个新的message
                let newIndexPath = IndexPath(row: messages.count, section: 0)
                
                messages.append(message)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
//            //保存数据
//            saveMessages()
        }
    }
    
    func reload() {
        messages.removeAll()
        loadMessages()
        
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
//    //存储数据
//    private func saveMessages() {
//        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(messages, toFile: Message.ArchiveURL.path)
//        
//        if isSuccessfulSave {
//            os_log("Messages are successful saved", log: .default, type: .debug)
//        }
//        else {
//            os_log("Failed to save", log: .default, type: .error)
//        }
//        
//    }
//    
//    //加载数据，可以return 一个 nil
//    private func loadMessages() -> [Message]? {
//        return NSKeyedUnarchiver.unarchiveObject(withFile: Message.ArchiveURL.path) as? [Message]
//    }
    
//    private func loadMessages(){
//        let query = LCQuery(className: "Packages")
//        //读取到的数据无论是否接单的，都要有
//        
//        
//        //发布的单的数量
//        var counts = query.count().intValue
//        //相当于一个保存了所有数据的数组
//        var allMessages = query.find().objects!
//        while (counts > 0) {
//            //逐个读取
//            let cloudMessage = allMessages.last
//            allMessages.popLast()
//            counts -= 1
//            
//            let message = self.cloudToLocal(message: cloudMessage!)
//            
//            let currentUser = LCUser.current!
//            let founderPhone = currentUser.mobilePhoneNumber?.stringValue
//            if (message?.founderPhone == founderPhone) {
//                messages.append(message!)
//            }
//        }
//    }
    private func loadMessages() {
        let query = AVQuery(className: "Packages")
        //读取到的数据无论是否接单的，都要有
        
        //发布的单的数量
        var counts = query.countObjects()
        var allMessages = query.findObjects()
        
        while (counts > 0) {
            let cloudMessage = allMessages?.popLast()
            counts -= 1
            
            let message = self.cloudToLocal(message: cloudMessage! as! AVObject)
            let currentUser = LCUser.current
            let founderPhone = currentUser?.mobilePhoneNumber?.stringValue
            if (message?.founderPhone == founderPhone) {
                messages.append(message!)
            }
            
        }
        
    }
    //自己定义一个函数，把leancloud上的LCObject变成我本地的Message形式
//    private func cloudToLocal(message: LCObject) -> Message? {
        //狗屎，这个搞了半天
//        let package = message.get("package")?.stringValue
//        let describe = message.get("describe")?.stringValue
//        let time = message.get("time")?.stringValue
//        let remark = message.get("remark")?.stringValue
//        
//        
//        
//        let name = message.get("name")?.stringValue
//        let phone = message.get("phone")?.stringValue
//        let address = message.get("address")?.stringValue
//        
//        let founderPhone = message.get("founderPhone")?.stringValue
//        
//        let courierPhone = message.get("courierPhone")?.stringValue
//        
//        let ID = message.objectId
//        let state = message.get("state")?.stringValue
//        
//        let message = Message(package: package, describe: describe, time: time, remark: remark, name: name, phone: phone, address: address, founderPhone: founderPhone!, founderAddress: "", courierPhone: courierPhone, courierAddress: "", photo: nil, ID: ID!, state: state)
//        
//        return message
//    }
    //自己定义一个函数，把leancloud上的AVObject变成我本地的Message形式
    private func cloudToLocal(message: AVObject) -> Message? {
        let package = message.object(forKey: "package") as! String
        let describe = message.object(forKey: "describe") as! String
        let time = message.object(forKey: "time") as! String
        let remark = message.object(forKey: "remark") as! String
        
        let name = message.object(forKey: "name") as! String
        let phone = message.object(forKey: "phone") as! String
        let address = message.object(forKey: "address") as! String
        
        //
        let file = message.object(forKey: "photo") as? AVFile
        let data = file?.getData()
        let photo = UIImage(data: data!)
        
        
        let founderPhone = message.object(forKey: "founderPhone") as! String
        
        let courierPhone = message.object(forKey: "courierPhone") as? String
        
        let ID = message.objectId!
        let state = message.object(forKey: "state") as! String
        
        let message = Message(package: package, describe: describe, time: time, remark: remark, name: name, phone: phone, address: address, founderPhone: founderPhone, founderAddress: "", courierPhone: courierPhone, courierAddress: "", photo: photo, ID: ID, state: state)
        
        return message
    }
}
