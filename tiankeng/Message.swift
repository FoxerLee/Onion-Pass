//
//  Message.swift
//  tiankeng
//
//  Created by 李源 on 2017/2/13.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit
import os.log
import LeanCloud

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
    
    var ID: LCString?
    
    var state: String?
    
//    //数据存储
//    struct PropertyKey {
//        static let package = "package"
//        static let name = "name"
//        static let founderPhone = "founderPhone"
//        static let phone = "phone"
//        static let address = "address"
//        static let photo = "photo"
//        static let ID = "ID"
//        static let isOrdered = "isOrdered"
//    }
    
    //档案？
//    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
//    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("messages")
    
    init?(package: String?, describe: String?, time: String?, remark: String?, name: String?, phone: String?, address: String?, founderPhone: String, founderAddress: String?, courierPhone: String?, courierAddress: String?, photo: UIImage?, ID: LCString, state: String?) {
        

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
    
//    //数据存储 NSCoding的相关函数 实现数据解码和编码
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(package, forKey: PropertyKey.package)
//        aCoder.encode(name, forKey: PropertyKey.name)
//        aCoder.encode(founderPhone, forKey: PropertyKey.founderPhone)
//        aCoder.encode(phone, forKey: PropertyKey.phone)
//        aCoder.encode(address, forKey: PropertyKey.address)
//        aCoder.encode(photo, forKey: PropertyKey.photo)
//        aCoder.encode(ID, forKey: PropertyKey.ID)
//        aCoder.encode(isOrdered, forKey: PropertyKey.isOrdered)
//    }
    
//    required convenience init?(coder aDecoder: NSCoder) {
//        
//        //保证都存在
//        guard let package = aDecoder.decodeObject(forKey: PropertyKey.package) as? String else {
//            os_log("Unable to decode the package for a Message object.", log: OSLog.default, type: .debug)
//            return nil
//        }
//        
//        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
//            os_log("Unable to decode the name for a Message object.", log: OSLog.default, type: .debug)
//            return nil
//        }
//        
//        guard let founderPhone = aDecoder.decodeObject(forKey: PropertyKey.founderPhone) as? String else {
//            os_log("Unable to decode the founderPhone for a Message object.", log: OSLog.default, type: .debug)
//            return nil
//        }
//        
//        guard let phone = aDecoder.decodeObject(forKey: PropertyKey.phone) as? String else {
//            os_log("Unable to decode the phone for a Message object.", log: OSLog.default, type: .debug)
//            return nil
//        }
//        
//        guard let address = aDecoder.decodeObject(forKey: PropertyKey.address) as? String else {
//            os_log("Unable to decode the address for a Message object.", log: OSLog.default, type: .debug)
//            return nil
//        }
//        
//        //可选的照片
//        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
//        
//        guard let ID = aDecoder.decodeObject(forKey: PropertyKey.ID) as? LCString else {
//            os_log("Unable to decode the ID for a Message object.", log: OSLog.default, type: .debug)
//            return nil
//        }
//        
//        guard let isOrdered = aDecoder.decodeObject(forKey: PropertyKey.isOrdered) as? LCBool else {
//            os_log("Unable to decode the isOrdered for a Message object.", log: OSLog.default, type: .debug)
//            return nil
//        }
//        
//        self.init(package: package, name: name, founderPhone: founderPhone, phone: phone, address: address, photo: photo, ID: ID, isOrdered: isOrdered)
//    }
//    
}
