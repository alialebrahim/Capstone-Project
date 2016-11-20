//
//  customTextView.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/17/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class customTextView: UITextView {
    
    var border = UIView()
    var originalBorderFrame: CGRect!
    var originalInsetBottom: CGFloat!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(border)
        originalInsetBottom = textContainerInset.bottom
        addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
    }
    
    deinit {
        removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override var frame: CGRect {
        didSet {
            border.frame = CGRect(x: 0, y: frame.height+contentOffset.y-border.frame.height, width: frame.width, height: border.frame.height+10)
            originalBorderFrame  = CGRect(x: 0, y: frame.height-border.frame.height, width: frame.width, height: border.frame.height);
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            border.frame = originalBorderFrame.offsetBy(dx: 0, dy: contentOffset.y)
        }
    }
    
    func addBottomBorderWith(Color color: UIColor, width: CGFloat) {
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: frame.height+contentOffset.y-width, width: self.frame.width, height: width)
        originalBorderFrame = CGRect(x: 0, y: frame.height-width, width: self.frame.width, height: width)
        textContainerInset.bottom = originalInsetBottom+width
    }
}
