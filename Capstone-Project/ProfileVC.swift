//
//  providerInfoVC.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 6/20/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Cosmos

protocol ProfileDelegate: class{
    func didSwipeLeft()
}

//provider tabs (profile, feed, services, chat?)
class ProfileVC: UIViewController, UIScrollViewDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImage: CircularImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var ratingStarsView: CosmosView!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var workingFields: UILabel!
    @IBOutlet weak var providersMobileNumber: UIButton!
    @IBOutlet weak var providersEmailAddress: UIButton!
    @IBOutlet weak var address: UILabel!

    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var remainingTasksView: UIView!
    
    @IBOutlet weak var completedTasksView: UIView!
    //MARK: Variables
    weak var delegate: ProfileDelegate?
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.view.backgroundColor = UIColor.whiteColor()
        configureNavigationBar()
        
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
        automaticallyAdjustsScrollViewInsets = false
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.userInteractionEnabled = true
        //TODO: obtain these information from the backend
        bioTextView.text = "A well-organized paragraph supports or develops a single controlling idea, which is expressed in a sentence called the topic sentence. A topic sentence has several important functions: it substantiates or supports an essay’s thesis statement; it unifies the content of a paragraph and directs the order of the sentence"
        bioTextView.textAlignment = .Justified
        bioTextView.editable = false
        bioTextView.selectable = false
        bioTextView.dataDetectorTypes = .Link
        bioTextView.contentInset = UIEdgeInsetsMake(0,-5,0,0)
        address.numberOfLines = 5
        address.text = "Sabah Al-Salem\nKuwait"
        let colors = [UIColor(hex: 0xB39DDB), UIColor(hex: 0x7E57C2)]
        self.view.setGradientBackground(colors)
        profileImage.addBorderWith(color: UIColor.whiteColor().colorWithAlphaComponent(0.7), borderWidth: 4)
        workingFields.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
//        workingFields.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
//        workingFields.layer.shadowOffset = CGSize(width: 0, height: 0)
//        workingFields.layer.shadowOpacity = 1
//        workingFields.layer.shadowRadius = 6
        providersMobileNumber.setTitle("1801801", forState: .Normal)
        providersMobileNumber.setTitleColor(UIColor(hex: 0xEAAE13), forState: .Normal)
        providersEmailAddress.setTitleColor(UIColor(hex: 0xEAAE13), forState: .Normal)
        providersEmailAddress.setTitle("testmail@gmail.com", forState: .Normal)
        contentView.backgroundColor = UIColor.clearColor()
        bioTextView.backgroundColor = UIColor.clearColor()
        workingFields.text = "Development Services, Design Services, Teaching Services"
        workingFields.numberOfLines = 4
        //topContainerView.backgroundColor = UIColor(hex: 0xB39DDB)
        topContainerView.backgroundColor = UIColor.clearColor()
        //remainingTasksView.backgroundColor = UIColor(hex: 0xB39DDB)
        remainingTasksView.backgroundColor = UIColor.clearColor()
        completedTasksView.addLeadingBorderWithColor(UIColor(hex: 0x7E57C2, alpha: 0.5), width: 1)
        completedTasksView.addBottomBorderWithColor(UIColor(hex: 0x7E57C2, alpha: 0.5), width: 1)
        remainingTasksView.addBottomBorderWithColor(UIColor(hex: 0x7E57C2, alpha: 0.5), width: 1)
        remainingTasksView.addTopBorderWithColor(UIColor(hex: 0x7E57C2, alpha: 0.5), width: 1)
        //completedTasksView.backgroundColor = UIColor(hex: 0xB39DDB)
        completedTasksView.backgroundColor = UIColor.clearColor()
        completedTasksView.addTopBorderWithColor(UIColor(hex: 0x7E57C2, alpha: 0.5), width: 1)
        //swipe gesture needed to navigate between tabs for the seeker
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeAction))
        swipeGesture.direction = .Left
        view.addGestureRecognizer(swipeGesture)
    }
    func configureNavigationBar() {
        let editProfileItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(editProfile))
        editProfileItem.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = editProfileItem

        let img = UIImage(named: "folder")!
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button.setBackgroundImage(img, forState: .Normal)
        button.addTarget(self, action: #selector(OfferedServices), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)

        
        //title color
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        
        
    }
    func OfferedServices() {
        performSegueWithIdentifier("OfferedServicesVC", sender: nil)
    }
    func editProfile() {
        performSegueWithIdentifier("EditProfileVC", sender: nil)
    }
    func createRatingView() {
        let color = UIColor.whiteColor()
        let ratingView = CosmosView()
        ratingView.settings.updateOnTouch = false
        ratingView.settings.fillMode = .Half
        ratingView.settings.emptyBorderColor = color
        ratingView.settings.filledBorderColor = color
        ratingView.settings.filledColor = color
        ratingView.settings.textColor = UIColor.whiteColor()
        ratingView.text = "(0)" //TODO: obtain from the backend
        ratingView.rating = 0 //TODO: obtain this from the backend
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ratingView)

        ratingView.topAnchor.constraintEqualToAnchor(workingFields.bottomAnchor, constant: 8).active = true
        ratingView.leadingAnchor.constraintEqualToAnchor(profileImage.trailingAnchor, constant: 8).active = true
    }
    func leftSwipeAction() {
        print("im here")
        delegate?.didSwipeLeft()
    }
    func adjustContentViewHeight() {
        var contentRect = CGRectZero;
        for view in self.contentView.subviews {
            contentRect = CGRectUnion(contentRect, view.frame)
        }
        if contentRect.size.height > contentViewHeight.constant {
            contentViewHeight.constant = contentRect.size.height + 20
        }
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

