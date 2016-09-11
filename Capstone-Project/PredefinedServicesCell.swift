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
    @IBOutlet weak var arrowImageView: UIImageView!
    
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
        let image = arrowImageView.image!
        let tintedImage = image.imageWithRenderingMode(.AlwaysTemplate)
        arrowImageView.image = tintedImage
        arrowImageView.tintColor = UIColor.whiteColor()
        priceView.addLeadingBorderWithColor(UIColor.whiteColor(), width: 1)
        priceView.addBottomBorderWithColor(UIColor.whiteColor(), width: 1)
        priceView.addTopBorderWithColor(UIColor.whiteColor(), width: 1)
        priceView.backgroundColor = UIColor(hex: 0x8168AE)
        servicePrice.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        serviceCurrency.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        serviceDescription.textAlignment = .Justified
        serviceDescription.textColor = UIColor(hex: 0x8168AE, alpha: 0.9)
        self.backgroundColor = UIColor.clearColor()
        containerView.backgroundColor = UIColor(hex: 0xD1C4E9)
        serviceTitle.textColor = UIColor(hex: 0x8168AE)
        containerView.clipsToBounds = true
    }
}
