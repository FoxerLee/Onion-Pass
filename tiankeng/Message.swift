//
//  Message.swift
//  tiankeng
//
//  Created by 李源 on 2017/2/13.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit
import os.log
//import LeanCloud

class Message: NSObject {
    
    var package: String?
    var describe: String?
    var time: String?
    var remark: String?
    
    var name: String?
    var phone: String?
    var address: String?
    
    var founderPhone: String
    var founderAddress: String?
    
    var courierPhone: String?
    var courierAddress: String?
    
    var photo: UIImage?
    
    var ID: String?
    
    var state: String?
    
    
    init?(package: String?, describe: String?, time: String?, remark: String?, name: String?, phone: String?, address: String?, founderPhone: String, founderAddress: String?, courierPhone: String?, courierAddress: String?, photo: UIImage?, ID: String, state: String?) {
        

        self.package = package
        self.describe = describe
        self.time = time
        self.remark = remark
        
        self.name = name
        self.phone = phone
        self.address = address
        
        self.founderPhone = founderPhone
        self.founderAddress = founderAddress
        
        self.courierPhone = courierPhone
        self.courierAddress = courierAddress
        
        self.photo = photo
        
        self.ID = ID
        
        self.state = state
    }
    
}
