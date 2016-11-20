//
//  serviceWithBidCell.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 11/13/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class serviceWithBidCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var bid: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 5
        containerView.layer.borderColor = UIColor(hex: 0x404040).cgColor
        containerView.layer.borderWidth = 1
        containerView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
