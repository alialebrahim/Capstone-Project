//
//  PublicServiceCell.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 9/13/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class PublicServiceCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var dueTo: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(hex: 0x404040).cgColor
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
