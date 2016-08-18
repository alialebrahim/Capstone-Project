//
//  SearchedProviderVC.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 8/17/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class SearchedProviderVC: UIViewController, ProfileDelegate, OfferedServicesDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    
    //MARK: Variables
    var currentViewController: UIViewController?
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: Functions
    func setup() {
        automaticallyAdjustsScrollViewInsets = false
        view.userInteractionEnabled = true
        segmentedControl.segmentedControlItems = ["Provider","Offered Services"]
        segmentedControl.selectedIndex = 0
        displayCurrentTab(segmentedControl.selectedIndex)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), forControlEvents: .ValueChanged)
    }
    func segmentedControlValueChanged() {
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParentViewController()
        displayCurrentTab(segmentedControl.selectedIndex)
    }
    func viewControllerForSelectedIndex(index: Int) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Provider", bundle: nil)
        switch index {
            case 0:
                let vc = storyboard.instantiateViewControllerWithIdentifier("ProviderProfile") as! ProfileVC
                vc.delegate = self
                return vc
            case 1:
                let vc = storyboard.instantiateViewControllerWithIdentifier("OfferedServices") as! OfferedServicesVC
                vc.delegate = self
                return vc
            default: break
        }
        return nil
    }
    func displayCurrentTab(tabIndex: Int) {
        
        if let vc = viewControllerForSelectedIndex(tabIndex) {
            addChildViewController(vc)
            didMoveToParentViewController(self)
            vc.view.frame = contentView.bounds
            contentView.addSubview(vc.view)
            currentViewController = vc
        }
        
    }
    
    //MARK: Profile Delegate
    func didSwipeLeft() {
        segmentedControl.selectedIndex = 1
        displayCurrentTab(segmentedControl.selectedIndex)
    }
    //MARK: OfferedServices Delegate
    func didSwipeRight() {
        segmentedControl.selectedIndex = 0
        displayCurrentTab(segmentedControl.selectedIndex)
    }
}
