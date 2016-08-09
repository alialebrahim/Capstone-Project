//
//  PredefinedServicesCell.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 6/25/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class PredefinedServicesCell: UITableViewCell {

    @IBOutlet weak var servicePrice: UILabel!
    @IBOutlet weak var serviceCurrency: UILabel!
    @IBOutlet weak var serviceTitle: UILabel!
    @IBOutlet weak var serviceDescription: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var selectionView: UIView!
    
    //this function is responsible for showing and hiding selection view
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionView.hidden = !selected
    }
    override func awakeFromNib() {
        configureCellAppearance()
    }
    func configureCellAppearance() {
        selectionStyle = .None
        containerView.layer.borderColor = UIColor(hex: 0x3399CC).CGColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
    }
}
