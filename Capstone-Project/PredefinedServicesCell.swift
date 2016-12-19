//
//  PredefinedServicesCell.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 6/25/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class PredefinedServicesCell: UITableViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var servicePrice: UILabel!
    @IBOutlet weak var serviceTitle: UILabel!
    @IBOutlet weak var serviceDescription: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    //this function is responsible for showing and hiding selection view
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionView.isHidden = !selected
    }
    override func awakeFromNib() {
        configureCellAppearance()
    }
    func configureCellAppearance() {
        selectionStyle = .none
        let image = arrowImageView.image!
        let tintedImage = image.withRenderingMode(.alwaysTemplate)
        arrowImageView.image = tintedImage
        arrowImageView.tintColor = UIColor(hex: 0x404040)
        priceView.addLeadingBorderWithColor(UIColor.white, width: 1)
        priceView.addBottomBorderWithColor(UIColor.white, width: 1)
        priceView.addTopBorderWithColor(UIColor.white, width: 1)
        priceView.backgroundColor = UIColor(hex: 0xa85783)
//        servicePrice.textColor = UIColor.white
        serviceDescription.textAlignment = .justified
        serviceDescription.textColor = UIColor(hex: 0x404040)
        self.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.clear
        containerView.addBorderWithColor(UIColor(hex: 0x404040), width: 1)
        containerView.layer.cornerRadius = 5
        serviceTitle.textColor = UIColor(hex: 0x404040)
        containerView.clipsToBounds = true
    }
}
