//
//  CircularImageView.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 5/29/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class CircularImageView: UIImageView {
    
    //MARK: Inits
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //this code is responsable for making a circular image.
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
    }
    //MARK: Functions
    func addBorderWith(color: UIColor, borderWidth: CGFloat) {
        //-borderWidth is used to make the border outside the imageview not to cover the picture.
        self.frame = self.frame.insetBy(dx: -borderWidth, dy: -borderWidth)
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
    }
}
