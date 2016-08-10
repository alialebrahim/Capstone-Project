//
//  LoginVC.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 6/19/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class ServicesVC: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var contentView: UIView! //will hold the view of a ViewController
    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    
    // MARK: Variables
    var currentViewController: UIViewController?
    
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    // MARK: Functions
    func setup() {
        segmentedControl.selectedIndex = 0
        displayCurrentTab(segmentedControl.selectedIndex)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), forControlEvents: .ValueChanged)
        
        navigationItem.title = "Username"
    }
    /*this function gets an instance of the view controller depending on the selected tab index*/
    func viewControllerForSelectedSegmentIndex(index: Int) -> UIViewController? {
        
        //TODO: change identified
        switch index {
        case 0 :
            if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("RequestedServicesVC") {
                return vc
            }
        case 1 :
            if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("WorkingOnVC") {
                return vc
            }
        default:
            break
        }
        return nil
    }
    
    //adds the current tab view controller as a child to this view controller and setup its frame.
    func displayCurrentTab(tabIndex: Int) {
        self.navigationItem.rightBarButtonItem = nil
        
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
//            navigationItem.rightBarButtonItem = nil
            if tabIndex == 0 {
                //TODO: Get username from the server
                navigationItem.title = "Requests"
                let myVC = vc as! RequestedServicesVC
                let editProfileItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(editProfileAction))
                navigationItem.rightBarButtonItem = editProfileItem
                //myVC.delegate = self
            }else if tabIndex == 1{
                navigationItem.title = "Working on"
                let myVC = vc as! WorkingOnVC
                let addServiceItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addNewServiceAction))
                navigationItem.rightBarButtonItem = addServiceItem
//                myVC.delegate = self
            }
            self.addChildViewController(vc)
            vc.didMoveToParentViewController(self)
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    func addNewServiceAction() {
        performSegueWithIdentifier("addPredefinedServiceVC", sender: self)
    }
    func editProfileAction() {
        performSegueWithIdentifier("editProvidersProfileVC", sender: self)
    }
    /*
        Segment control target function
        each time the tab changes, first remove the old view controller
        then display the new tab view controller
     */
    func segmentedControlValueChanged() {
        /*removing the child ViewController is more memory effecient*/
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParentViewController()
        
        displayCurrentTab(segmentedControl.selectedIndex)
        
    }
    // MARK: Delegates functions
    /*
        for both delegate functions, if did not call
        segmentedControlValueChanged() function, the current viewController
        will not be removed from memeory and both views will overlay
     */
    func didSwipeLeft() {
        segmentedControl.selectedIndex = 1
        segmentedControlValueChanged()
    }
    func didSwipeRight() {
        segmentedControl.selectedIndex = 0
        segmentedControlValueChanged()
    }
}