//
//  LoadingView.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 10/22/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    static var myView: UIView!
    static var activity: UIActivityIndicatorView!
    static var label: UILabel!
    class func addLoadingViewTo(_ parentView: UIView) {
        myView = UIView(frame: CGRect(x: 0, y: 0, width: parentView.frame.width, height: parentView.frame.height))
        myView.isHidden = true
        myView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        parentView.addSubview(myView)
        activity = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activity.center = myView.center
        myView.addSubview(activity)
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        myView.addSubview(label)
        label.topAnchor.constraint(equalTo: activity.bottomAnchor, constant: 20).isActive = true
        label.centerXAnchor.constraint(equalTo: myView.centerXAnchor).isActive = true
        
        
    }
    class func startAnimatingWithMessage(_ message: String) {
        print("LOADING ANIMATION")
        label.text = message
        myView.isHidden = false
        activity.startAnimating()
    }
    class func stopAnimating() {
        myView.isHidden = true
        activity.stopAnimating()
        myView.removeFromSuperview()
    }
}
