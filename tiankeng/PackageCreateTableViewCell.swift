//
//  PackageCreateTableViewCell.swift
//  tiankeng
//
//  Created by 李源 on 2017/3/19.
//  Copyright © 2017年 foxerlee. All rights reserved.
//

import UIKit

class PackageCreateTableViewCell: UITableViewCell {
    @IBOutlet weak var packageLabel: UILabel!
    @IBOutlet weak var describeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
