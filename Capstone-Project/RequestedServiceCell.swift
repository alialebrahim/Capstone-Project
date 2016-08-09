//
//  RequestedServiceCell.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/26/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class RequestedServiceCell: UITableViewCell {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dueToLabel: UILabel!
    @IBOutlet weak var requestedOnLabel: UILabel!
    @IBOutlet weak var seekerUsernameButton: UIButton!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func seekerUsernameButtonPressed() {
        print("seeker username was pressed")
    }

}
