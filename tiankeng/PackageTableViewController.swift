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

class PackageTableViewController: UITableViewController {

    var messages = [Message]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.editButtonItem.title = "确认送达"

//        let currentUser = LCUser.current!
//        let founderPhone = currentUser.mobilePhoneNumber?.stringValue
        
//        //加载任何保存了的数据
//        if var savedMessages = loadMessages() {
//            var counts = savedMessages.count
//            while (counts > 0){
//                let message = savedMessages.last
//                savedMessages.popLast()
//                counts -= 1
//                //为了保证显示出来的数据是当前使用者发布的
//                if (message?.founderPhone == founderPhone) {
//                    messages.append(message!)
//                }
//            }
//        }
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
        cell.phoneLabel.text = message.phone
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
            query.whereKey("objectId", .equalTo(message.ID))
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
            guard let MessageDetailViewController = segue.destination as? DetailViewController else {
                fatalError("Unexpeted destination: \(segue.destination)")
            }
            
            guard let selectedPackageCell = sender as? PackageTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
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
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    
    //添加新的一个cell
    @IBAction func unwindToPackageMessage(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? CreateViewController, let message = sourceViewController.message {
            
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
    
    private func loadMessages(){
        let query = LCQuery(className: "Packages")
        //读取到的数据无论是否接单的，都要有
        //query.whereKey("isOrdered", .equalTo(false))
        
        //发布的单的数量
        var counts = query.count().intValue
        //相当于一个保存了所有数据的数组
        var allMessages = query.find().objects!
        while (counts > 0) {
            //逐个读取
            let cloudMessage = allMessages.last
            allMessages.popLast()
            counts -= 1
            
            let message = self.cloudToLocal(message: cloudMessage!)
            
            let currentUser = LCUser.current!
            let founderPhone = currentUser.mobilePhoneNumber?.stringValue
            if (message?.founderPhone == founderPhone) {
                messages.append(message!)
            }
//            self.messages.append(message!)
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
        let isOrdered = message.get("isOrdered")?.stringValue
        
        let message = Message(package: package!, name: name!, founderPhone: founderPhone!, phone: phone!, address: address!, photo: nil, ID: ID!, isOrdered: isOrdered!)
        
        return message
    }


}
