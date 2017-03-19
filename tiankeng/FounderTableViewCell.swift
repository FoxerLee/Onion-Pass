//
//  FounderTableViewCell.swift
//  tiankeng
//
//  Created by 李源 on 2017/3/19.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit

class FounderTableViewCell: UITableViewCell {
    @IBOutlet weak var founderNameLabel: UILabel!
    @IBOutlet weak var FounderPhoneLabel: UILabel!
    @IBOutlet weak var founderAddressLabel: UILabel!

    @IBOutlet weak var founderImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
