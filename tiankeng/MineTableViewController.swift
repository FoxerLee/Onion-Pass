//
//  MineTableViewController.swift
//  tiankeng
//
//  Created by 李源 on 2017/4/4.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit
import AVOSCloud

class MineTableViewController: UITableViewController {

    var iconImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()

        //使得每一个cell的高度可以在storyborad自定义
        iconImage = UIImage(named: "Sample Image")
        
        self.tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "PhotoTableViewCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            return 1
        }
        else if (section == 1){
            return 2
        }
        else {
            return 1
        }
    }

    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if (indexPath.section == 0){
//            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as! PhotoTableViewCell
//            cell.iconImageView.image = iconImage!
//            return cell
//        }
//        else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
//            
//            return cell
//        }
//    }
    
    //prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "ChangeIcon":
            guard let SourceViewController = segue.destination as? PhotoViewController else {
               fatalError("Unexpeted destination: \(segue.destination)")
            }
            SourceViewController.hidesBottomBarWhenPushed = true
        
            break
        case "ChangeName":
            guard let SourceViewController = segue.destination as? NameTableViewController else {
                fatalError("Unexpeted destination: \(segue.destination)")
            }
            SourceViewController.hidesBottomBarWhenPushed = true
            
            break
        case "ChangeAddress":
            guard let SourceViewController = segue.destination as? AddressTableViewController else {
                fatalError("Unexpeted destination: \(segue.destination)")
            }
            SourceViewController.hidesBottomBarWhenPushed = true
            
            break
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")

        }
    }
 
    @IBAction func unwindToSaveIconButton(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PhotoViewController, let iconImage = sourceViewController.iconImage {
//            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                self.iconImage = iconImage
                
                let data = UIImagePNGRepresentation(iconImage)
                let photo = AVFile.init(data: data!)
                
                let currentUser = AVUser.current()
                currentUser?.setObject(photo, forKey: "icon")
                currentUser?.save()
                
                
           //     tableView.reloadRows(at: [selectedIndexPath], with: .none)
//            }
        }
    }
    
    @IBAction func unwindToSaveNameButton(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NameTableViewController, let nickName = sourceViewController.nickName {
            
            let currentUser = AVUser.current()
            currentUser?.setObject(nickName, forKey: "username")
            currentUser?.save()
            
        }
    }
    
    @IBAction func unwindToSaveAddressButton(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddressTableViewController, let address = sourceViewController.address {
            
            let currentUser = AVUser.current()
            currentUser?.setObject(address, forKey: "address")
            currentUser?.save()
            
        }
    }
    @IBAction func LogOut(_ sender: Any) {
        AVUser.logOut()
        //切换回登陆界面
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "LVC") as! ViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    
}
