//
//  errorButton.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 8/3/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class ErrorButton: UIButton {
    
    //MARK: Variables
    var errorMessage: String!
    
    init(withMessage message: String, isAssociateWith textField: UITextField) {
        super.init(frame: CGRect.zero)
        errorMessage = message
        let frame: CGRect = textField.frame
        let buttonYPoint = frame.origin.y + 10
        let buttonXPoint = frame.origin.x + frame.width - 40
        self.frame = CGRect(x: buttonXPoint, y: buttonYPoint, width: 20 , height: 20)
        let explanationMarkImage = UIImage(named: "explanation_mark")
        self.setImage(explanationMarkImage, for: UIControlState())
        self.imageView?.contentMode = .scaleAspectFit
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
