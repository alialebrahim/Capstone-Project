//
//  SubmitButton.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 8/20/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
protocol SubmitButtonDelegate: class {
    func didAnimate(frame: CGRect)
    //func removeAnimation()
}
class SubmitButton: UIButton {
    
    weak var delegate: SubmitButtonDelegate?
    lazy var indicator: NVActivityIndicatorView! = {
        let activityIndicator = NVActivityIndicatorView(frame: self.bounds, type: .BallScaleRippleMultiple, color: UIColor.whiteColor())
        return activityIndicator
    }()
     var didEndFinishAnimation : (()->())? = nil
    
    let springGoEase = CAMediaTimingFunction(controlPoints: 0.45, -0.36, 0.44, 0.92)
    let shrinkCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    let expandCurve = CAMediaTimingFunction(controlPoints: 0.95, 0.02, 1, 0.05)
    let shrinkDuration: CFTimeInterval  = 0.1
    var cachedTitle: String?
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
     required init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }
    
    func setup() {
        self.clipsToBounds = true
    }
    
     func startLoadingAnimation() {
        self.setTitle("", forState: .Normal)
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.layer.cornerRadius = self.frame.height / 2
        }) { (done) -> Void in
            self.shrink()
        }
        
    }
    
     func startFinishAnimation(delay: NSTimeInterval, completion:(()->())?) {
        NSTimer.schedule(delay: delay) { timer in
            self.didEndFinishAnimation = completion
            self.expand()
        }
    }
    
     func animate(duration: NSTimeInterval, completion:(()->())?) {
        startLoadingAnimation()
        startFinishAnimation(duration, completion: completion)
    }
    
     func setOriginalState() {
        self.returnToOriginalState()
    }
    
     override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        let a = anim as! CABasicAnimation
        if a.keyPath == "transform.scale" {
            didEndFinishAnimation?()
            NSTimer.schedule(delay: 1) { timer in
                self.returnToOriginalState()
            }
        }
    }
    
     func returnToOriginalState() {
        
        self.layer.removeAllAnimations()
        self.setTitle(self.cachedTitle, forState: .Normal)
        //self.delegate.removeAnimation()
    }
    
    func shrink() {
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue = frame.width
        shrinkAnim.toValue = frame.height
        shrinkAnim.duration = shrinkDuration
        shrinkAnim.timingFunction = shrinkCurve
        shrinkAnim.fillMode = kCAFillModeForwards
        shrinkAnim.removedOnCompletion = false
        layer.addAnimation(shrinkAnim, forKey: shrinkAnim.keyPath)
        self.delegate?.didAnimate(self.frame)
    }
    
    func expand() {
        let expandAnim = CABasicAnimation(keyPath: "transform.scale")
        expandAnim.fromValue = 1.0
        expandAnim.toValue = 26.0
        expandAnim.timingFunction = expandCurve
        expandAnim.duration = 0.3
        expandAnim.delegate = self
        expandAnim.fillMode = kCAFillModeForwards
        expandAnim.removedOnCompletion = false
        layer.addAnimation(expandAnim, forKey: expandAnim.keyPath)
    }
}
