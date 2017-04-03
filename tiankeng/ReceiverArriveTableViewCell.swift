//
//  ReceiverArriveTableViewCell.swift
//  tiankeng
//
//  Created by 李源 on 2017/4/3.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit

class ReceiverArriveTableViewCell: UITableViewCell {

    @IBOutlet weak var ReceiverNameLabel: UILabel!
    @IBOutlet weak var ReceiverPhoneLabel: UILabel!
    @IBOutlet weak var ReceiverAddressLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
