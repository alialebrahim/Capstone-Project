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
        return emailTest.evaluate(with: self)
    }
    /*
     username:
        1)length of the username should be in the range 6-15
        2)username can contain set of [A-Z], [a-z], [0-9], underscores, and hyphen
     */
    func isValidUsername() -> Bool {
        let usernameRegEx = "[A-Z0-9a-z._-]{6,15}"
        let usernameTest = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        return usernameTest.evaluate(with: self)
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
        return passwordTest.evaluate(with: self)
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
        
        let from_point = CGPoint(x: self.center.x - xDelta, y: self.center.y)
        let from_value = NSValue(cgPoint: from_point)
        
        let to_point = CGPoint(x: self.center.x + xDelta, y: self.center.y)
        let to_value = NSValue(cgPoint: to_point)
        
        shake.fromValue = from_value
        shake.toValue = to_value
        shake.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.layer.add(shake, forKey: "position")
    }
    func addBorderWithColor(_ color: UIColor, width: CGFloat){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    func addLeadingBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = false
    }
    func addTopBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: width)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = false
    }
    func addBottomBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = false
    }
    func setGradientBackground(_ colors: [UIColor]) {
        var gradientColors = [CGColor]()
        for color in colors {
            gradientColors.append(color.cgColor)
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = [ 0.0, 1.0]
//        gradientLayer.startPoint = CGPointMake(1,0)
//        gradientLayer.endPoint = CGPointMake(0,1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
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
extension Date {
    func isGreaterThanDate(_ Date: Foundation.Date) -> Bool {
        var isGreater = false
        if self.compare(Date) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        return isGreater
    }
    func isLessThanDate(_ Date: Foundation.Date) -> Bool {
        var isLess = false
        if self.compare(Date) == ComparisonResult.orderedAscending {
            isLess = true
        }
        return isLess
    }
    func equalToDate(_ Date: Foundation.Date) -> Bool {
        if ((Calendar.current as NSCalendar).compare(self, to: Date, toUnitGranularity: .hour)) == .orderedSame
            && ((Calendar.current as NSCalendar).compare(self, to: Date, toUnitGranularity: .minute)) == .orderedSame {
            return true
        }
        return false
    }
}

//MARK: Array
extension Array {
    //This method works with any object that implements the Equatable protocol
    mutating func removeObject<U: Equatable>(_ object: U) -> Bool {
        for (idx, objectToCompare) in self.enumerated() {
            if let to = objectToCompare as? U {
                if object == to {
                    self.remove(at: idx)
                    return true
                }
            }
        }
        return false
    }
}
//MARK: NSTimer
extension Timer {
    class func schedule(delay: TimeInterval, handler: ((Timer?) -> Void)!) -> Timer! {
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, .commonModes)
        return timer
    }
    class func schedule(repeatInterval interval: TimeInterval, handler: ((Timer?) -> Void)!) -> Timer! {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, .commonModes)
        return timer
    }
}

