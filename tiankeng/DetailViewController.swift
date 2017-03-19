//
//  DetailViewController.swift
//  tiankeng
//
//  Created by 李源 on 2017/2/15.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var packageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!

    var message: Message?
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.hidesBottomBarWhenPushed = false
        
        //把tableView的cell内容显示到这里
        if let message = message {
            packageLabel.text = message.package
            nameLabel.text = message.name
            phoneLabel.text = message.phone
            addressLabel.text = message.address
            stateLabel.text = message.state
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
