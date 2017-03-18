//
//  ConfirmViewController.swift
//  tiankeng
//
//  Created by 李源 on 2017/3/8.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit
import LeanCloud

class ConfirmViewController: UIViewController {

    @IBOutlet weak var packageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var founderNameLabel: UILabel!
    @IBOutlet weak var founderPhoneLabel: UILabel!
    @IBOutlet weak var founderAddressLabel: UILabel!
    
    var message: Message?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hidesBottomBarWhenPushed = false
        
        if let message = message {
            packageLabel.text = message.package
            nameLabel.text = message.name
            phoneLabel.text = message.phone
            addressLabel.text = message.address
            
            founderPhoneLabel.text = message.founderPhone
            
            let query = LCQuery(className: "_User")
            query.whereKey("mobilePhoneNumber", .equalTo(message.founderPhone))
            let founder = query.getFirst().object
            let founderName = founder?.get("username")?.stringValue
            founderNameLabel.text = founderName
            //之后有了地址再加进来
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    




}
