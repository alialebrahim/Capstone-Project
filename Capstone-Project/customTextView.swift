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
        addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
    }
    
    deinit {
        removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override var frame: CGRect {
        didSet {
            border.frame = CGRectMake(0, frame.height+contentOffset.y-border.frame.height, frame.width, border.frame.height+10)
            originalBorderFrame  = CGRectMake(0, frame.height-border.frame.height, frame.width, border.frame.height);
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentOffset" {
            border.frame = CGRectOffset(originalBorderFrame, 0, contentOffset.y)
        }
    }
    
    func addBottomBorderWith(Color color: UIColor, width: CGFloat) {
        border.backgroundColor = color
        border.frame = CGRectMake(0, frame.height+contentOffset.y-width, self.frame.width, width)
        originalBorderFrame = CGRectMake(0, frame.height-width, self.frame.width, width)
        textContainerInset.bottom = originalInsetBottom+width
    }
}
