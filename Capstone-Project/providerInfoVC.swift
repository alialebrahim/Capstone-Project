//
//  providerInfoVC.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 6/20/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Cosmos

//MARK: Protocol
protocol ProviderInfoDelegate: class {
    func didSwipeLeft()
}
class ProviderInfoVC: UIViewController, UIScrollViewDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImage: CircularImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var ratingStarsView: CosmosView!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var workingFields: UILabel!
    @IBOutlet weak var providersMobileNumber: UIButton!
    @IBOutlet weak var providersEmailAddress: UIButton!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    //MARK: Variables
    weak var delegate: ProviderInfoDelegate?
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        createRatingView()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        adjustContentViewHeight()
    }
    
    //MARK: IBActions
    @IBAction func callProviderButtonPressed() {
        if let phoneNumberString = providersMobileNumber.currentTitle {
            if let phoneNumberURL = NSURL(string: "telprompt://\(phoneNumberString)") {
                if UIApplication.sharedApplication().canOpenURL(phoneNumberURL) {
                    UIApplication.sharedApplication().openURL(phoneNumberURL)
                }
            }
        }
    }
    @IBAction func emailProviderButtonPressed(sender: AnyObject) {
        print("hello")
        if let emailString = providersEmailAddress.currentTitle {
            if let emailURL = NSURL(string: "mailto://\(emailString)"){
                if UIApplication.sharedApplication().canOpenURL(emailURL) {
                    UIApplication.sharedApplication().openURL(emailURL)
                }
            }
            
        }
    }
    //MARK: Functions
    func setup() {
        scrollView.userInteractionEnabled = true
        //TODO: obtain these information from the backend
        bioTextView.text = "A well-organized paragraph supports or develops a single controlling idea, which is expressed in a sentence called the topic sentence. A topic sentence has several important functions: it substantiates or supports an essay’s thesis statement; it unifies the content of a paragraph and directs the order of the sentence"
        bioTextView.editable = false
        bioTextView.layer.cornerRadius = 7
        bioTextView.layer.borderWidth = 1
        bioTextView.layer.borderColor = UIColor(hex: 0x3399CC).CGColor
        
        profileImage.addBorderWith(color: UIColor(hex: 0x3399CC), borderWidth: 1)
        
        providersMobileNumber.setTitle("1801801", forState: .Normal)
        providersEmailAddress.setTitle("testmail@gmail.com", forState: .Normal)
        
        workingFields.text = "Teaching, App Development, Web Development"
        
        //swipe gesture needed to navigate between tabs
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        swipeGesture.direction = .Left
        view.addGestureRecognizer(swipeGesture)
    }
    func createRatingView() {
        let color = UIColor(hex: 0x3399CC)
        let ratingView = CosmosView()
        ratingView.settings.updateOnTouch = false
        ratingView.settings.fillMode = .Half
        ratingView.settings.emptyBorderColor = color
        ratingView.settings.filledBorderColor = color
        ratingView.settings.filledColor = color
        ratingView.text = "(0)" //TODO: obtain from the backend
        ratingView.rating = 5 //TODO: obtain this from the backend
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ratingView)

        ratingView.topAnchor.constraintEqualToAnchor(username.bottomAnchor, constant: 8).active = true
        ratingView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
    }
    func swipeAction() {
        delegate?.didSwipeLeft()
    }
    func adjustContentViewHeight() {
        var contentRect = CGRectZero;
        for view in self.contentView.subviews {
            contentRect = CGRectUnion(contentRect, view.frame)
        }
        contentViewHeight.constant = contentRect.size.height + 20
    }
}

