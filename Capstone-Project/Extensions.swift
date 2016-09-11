//
//  classesExtensions.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 6/21/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//


//MARK: String
extension String {
    //validation for usename, and email using regular expression.
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
    /*
     username:
        1)length of the username should be in the range 6-15
        2)username can contain set of [A-Z], [a-z], [0-9], underscores, and hyphen
     */
    func isValidUsername() -> Bool {
        let usernameRegEx = "[A-Z0-9a-z._-]{6,15}"
        let usernameTest = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        return usernameTest.evaluateWithObject(self)
    }
    /*
     password:
        1)length should be >= 6 && <= 15
        2)should contain digits
        3)should contain upper and lower case charecters
     */
    func isValidPassword() -> Bool {
        let passwordRegEx = "(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,15}"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluateWithObject(self)
    }
}
// MARK: UIView
extension UIView {
    
    func shakeView() {
        let shake = CABasicAnimation(keyPath: "position")
        let xDelta = CGFloat(5)
        shake.duration = 0.08
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let from_point = CGPointMake(self.center.x - xDelta, self.center.y)
        let from_value = NSValue(CGPoint: from_point)
        
        let to_point = CGPointMake(self.center.x + xDelta, self.center.y)
        let to_value = NSValue(CGPoint: to_point)
        
        shake.fromValue = from_value
        shake.toValue = to_value
        shake.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.layer.addAnimation(shake, forKey: "position")
    }
    func addBorderWithColor(color: UIColor, width: CGFloat){
        self.layer.borderColor = color.CGColor
        self.layer.borderWidth = width
    }
    func addLeadingBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRectMake(0, 0, width, self.frame.size.height)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = false
    }
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRectMake(0, 0, self.frame.width, width)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = false
    }
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = false
    }
    func setGradientBackground(colors: [UIColor]) {
        var gradientColors = [CGColor]()
        for color in colors {
            gradientColors.append(color.CGColor)
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = [ 0.0, 1.0]
//        gradientLayer.startPoint = CGPointMake(1,0)
//        gradientLayer.endPoint = CGPointMake(0,1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, atIndex: 0)
        //self.layer.addSublayer(gradientLayer)
    }

}
// MARK: UIColor
extension UIColor {
    // Usage: UIColor(hex: 0xFC0ACE)
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1)
    }
    
    // Usage: UIColor(hex: 0xFC0ACE, alpha: 0.25)
    convenience init(hex: Int, alpha: Double) {
        self.init(
            red: CGFloat((hex >> 16) & 0xff) / 255,
            green: CGFloat((hex >> 8) & 0xff) / 255,
            blue: CGFloat(hex & 0xff) / 255,
            alpha: CGFloat(alpha))
    }
}

//MARK: NSDate
extension NSDate {
    func isGreaterThanDate(Date: NSDate) -> Bool {
        var isGreater = false
        if self.compare(Date) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        return isGreater
    }
    func isLessThanDate(Date: NSDate) -> Bool {
        var isLess = false
        if self.compare(Date) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        return isLess
    }
    func equalToDate(Date: NSDate) -> Bool {
        if (NSCalendar.currentCalendar().compareDate(self, toDate: Date, toUnitGranularity: .Hour)) == .OrderedSame
            && (NSCalendar.currentCalendar().compareDate(self, toDate: Date, toUnitGranularity: .Minute)) == .OrderedSame {
            return true
        }
        return false
    }
}

//MARK: Array
extension Array {
    //This method works with any object that implements the Equatable protocol
    mutating func removeObject<U: Equatable>(object: U) -> Bool {
        for (idx, objectToCompare) in self.enumerate() {
            if let to = objectToCompare as? U {
                if object == to {
                    self.removeAtIndex(idx)
                    return true
                }
            }
        }
        return false
    }
}
//MARK: NSTimer
extension NSTimer {
    class func schedule(delay delay: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
    
    class func schedule(repeatInterval interval: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
}

