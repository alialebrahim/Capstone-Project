//
//  RequestedServiceCell.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/26/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class WorkingOnServiceCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dueToLabel: UILabel!
    @IBOutlet weak var requestedOnLabel: UILabel!
    @IBOutlet weak var seekerUsernameButton: UIButton!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 5
        containerView.layer.borderColor = UIColor(hex: 0x404040).cgColor
        containerView.layer.borderWidth = 1
        containerView.clipsToBounds = true
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func seekerUsernameButtonPressed() {
        print("seeker username was pressed")
    }

}
