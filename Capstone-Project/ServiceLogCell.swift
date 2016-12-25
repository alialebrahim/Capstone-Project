//
//  ServiceLogCell.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 12/24/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class ServiceLogCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var provider: UIButton!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var timeDone: UILabel!
    @IBOutlet weak var timeCreated: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
