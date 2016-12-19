//
//  ProfileCell.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 8/16/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class ProviderCell: UITableViewCell {

    @IBOutlet weak var about: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profileImageView: CircularImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
