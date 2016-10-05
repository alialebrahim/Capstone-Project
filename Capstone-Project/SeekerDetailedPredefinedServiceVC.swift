//
//  SeekerDetailedPredefinedServiceVC.swift
//  Khedmat
//
//  Created by Yousif Al-Huwaidi on 8/8/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

//import UIKit
//
//class SeekerDetailedPredefinedServiceVC: UIViewController , UITableViewDelegate , UITableViewDataSource , iCarouselDelegate , iCarouselDataSource {
//    
//    
//    @IBOutlet weak var ServiceTitleLabel: UILabel!
//    @IBOutlet weak var ServiceDescriptionTextView: UITextView!
//    @IBOutlet weak var ServicePriceLabel: UILabel!
//    @IBOutlet weak var WorkingHoursTableView: UITableView!
//    @IBOutlet weak var CarouselView: iCarousel!
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var contentView: UIView!
//    
//    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var requestButton: UIButton!
//    
//    var ServiceID = 5
//    var UserType = 0
//    var ServiceTitle = "Building iOS Application"
//    
//    var ServiceDescription = "This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description"
//    var ServicePrice = "7 KWD"
//    var Images = [UIImage]()
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        Images = [UIImage(named: "Image1")! , UIImage(named: "Image2")!]
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        //TODO: put it in a function.
//        scrollView.userInteractionEnabled = true
//        var contentRect = CGRectZero;
//        
//        for view in self.contentView.subviews {
//            contentRect = CGRectUnion(contentRect, view.frame)
//        }
//        contentViewHeightConstraint.constant = contentRect.size.height + 20
//        
//        
//        
//    }
//    override func viewDidLoad() {
//
//        requestButton.setTitleColor(UIColor(hex: 0x3399CC), forState: .Normal)
//        requestButton.layer.cornerRadius = 7
//        requestButton.layer.borderWidth = 2.0
//        requestButton.layer.borderColor = UIColor(hex: 0x3399CC).CGColor
//            
//
//        LabelsSetting()
//        ServiceTitleLabel.text = ServiceTitle
//        ServiceDescriptionTextView.text = ServiceDescription
//        ServicePriceLabel.text = ServicePrice
//    }
//    
//    
//    @IBAction func requestPressed() {
//        requestPredefineService()
//    }
//    
//    
//    
//    
//    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
//        return Images.count
//    }
//    
//    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
//        let tempView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        tempView.contentMode = .ScaleAspectFill
//        tempView.clipsToBounds = true
//        tempView.image = Images[index]
//        return tempView
//    }
//    
//    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
//        if option == iCarouselOption.Spacing {
//            return value*1.1
//        }
//        return value
//    }
//    
//    func carousel(carousel: iCarousel, didSelectItemAtIndex index: Int) {
//        performSegueWithIdentifier("ImagePreviewSegue", sender: index)
//    }
//    func LabelsSetting (){
//        ServiceTitleLabel.textColor = UIColor(hex: 0x3399CC)
//        ServiceDescriptionTextView.editable = false
//        ServiceDescriptionTextView.layer.cornerRadius = 7
//        ServiceDescriptionTextView.layer.borderWidth = 1
//        ServiceDescriptionTextView.layer.borderColor = UIColor(hex: 0x3399CC).CGColor
//        ServicePriceLabel.textColor = UIColor(hex: 0x3399CC)
//    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "editPredefinedServiceSegue" {
//            if let destination = segue.destinationViewController as? addPredefinedService {
//                destination.serviceID = ServiceID
//                destination.buttonName = "Save"
//            }
//        } else {
//            let myIndex = sender as? Int
//            if segue.identifier == "ImagePreviewSegue" {
//                if let destination = segue.destinationViewController as? ImagePreview {
//                    if let Index = myIndex {
//                        destination.image = Images[Index]
//                        destination.imageIndex = Index
//                    }
//                }
//            }
//        }
//    }
//    
//    
//    
//    func editPredefineService () {
//        performSegueWithIdentifier("editPredefinedServiceSegue", sender: nil)
//    }
//    
//    func requestPredefineService () {
//        //request predefined service from the server
//        self.navigationController?.popViewControllerAnimated(true)
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 12
//    }
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = self.WorkingHoursTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! WorkingHoursCell
//        cell.WorkingHoursLabel.text = "6 AM to 9 PM"
//        return cell
//    }
//}

import UIKit

class SeekerDetailedPredefinedServiceVC: UIViewController , UITableViewDelegate , UITableViewDataSource , iCarouselDelegate , iCarouselDataSource , UIPopoverPresentationControllerDelegate,AvailableServiceDaysDelegate {
    
    @IBOutlet weak var ServiceTitleLabel: UILabel!
    @IBOutlet weak var ServiceDescriptionTextView: UITextView!
    @IBOutlet weak var ServicePriceLabel: UILabel!
    @IBOutlet weak var WorkingHoursTableView: UITableView!
    @IBOutlet weak var CarouselView: iCarousel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var availableServiceDaysButton: UIButton!
    
    var ServiceID = 5 //getting it from the server
    var UserType = 0
    var ServiceTitle = "Building iOS Application"
    var availableServiceDays = [Int]()
    var daysTime = [3 , 3 , 3 , 3 , 3 , 3 , 3] //getting it from the server
    var availableHours = [[01 , 02 , 03] , [11 , 12 , 13]  , [21 , 22 , 23] , [31 , 32 , 33] , [41 , 42 , 43] , [51 , 52 , 53] , [61 , 62 , 63]] //getting it from the server
    var selectedTimeIndex = -1
    var daySelected = false
    var ServiceDescription = "This is a service description." //getting it from the server
    var ServicePrice = "7 KWD" //getting it from the server
    var Images = [UIImage]() //getting it from the server
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Images = [UIImage(named: "Image1")! , UIImage(named: "Image2")!]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //TODO: put it in a function.
        
        scrollViewSetting()
    }
    
    override func viewDidLoad() {
        navigationItem.title = "Service Details"
        LabelsSetting()
        ServiceTitleLabel.text = ServiceTitle
        ServiceDescriptionTextView.text = ServiceDescription
        ServicePriceLabel.text = ServicePrice
    }
    
    @IBAction func requestPressed() {
        //request predefined service from the server
        print("\nDays: \(availableServiceDays)\n")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func availableServiceDaysButtonPressed() {
        performSegueWithIdentifier("availableServiceDays", sender: self)
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return Images.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        let tempView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        tempView.contentMode = .ScaleAspectFill
        tempView.clipsToBounds = true
        tempView.image = Images[index]
        return tempView
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.Spacing {
            return value*1.1
        }
        return value
    }
    
    func carousel(carousel: iCarousel, didSelectItemAtIndex index: Int) {
        performSegueWithIdentifier("ImagePreviewSegue", sender: index)
    }
    
    func LabelsSetting (){
        ServiceTitleLabel.textColor = UIColor(hex: 0x3399CC)

        ServiceDescriptionTextView.editable = false
        ServiceDescriptionTextView.layer.cornerRadius = 7
        ServiceDescriptionTextView.layer.borderWidth = 1
        ServiceDescriptionTextView.layer.borderColor = UIColor(hex: 0x3399CC).CGColor
        
        ServicePriceLabel.textColor = UIColor(hex: 0x3399CC)
        
        requestButton.setTitleColor(UIColor(hex: 0x3399CC), forState: .Normal)
        requestButton.layer.cornerRadius = 7
        requestButton.layer.borderWidth = 2.0
        requestButton.layer.borderColor = UIColor(hex: 0x3399CC).CGColor
    }
    
    func scrollViewSetting () {
        scrollView.userInteractionEnabled = true
        var contentRect = CGRectZero;
        
        for view in self.contentView.subviews {
            contentRect = CGRectUnion(contentRect, view.frame)
        }
        
        contentViewHeightConstraint.constant = contentRect.size.height + 20
    }
    
    func shouldDismissDaysView(days: [Int]) {
            
        if !days.isEmpty {
            availableServiceDays = days
            daySelected = true
            self.WorkingHoursTableView.reloadData()
            print(availableServiceDays)
            availableServiceDaysButton.setTitle("Select Day", forState: .Normal)
        }else {
            availableServiceDaysButton.setTitle("+Select Day", forState: .Normal)
        }
        
        presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editPredefinedServiceSegue" {
            if let destination = segue.destinationViewController as? addService {
                //destination.serviceID = ServiceID
                destination.buttonName = "Save"
            }
            
        } else {
            let myIndex = sender as? Int
            if segue.identifier == "ImagePreviewSegue" {
                if let destination = segue.destinationViewController as? ImagePreview {
                    if let Index = myIndex {
                        destination.image = Images[Index]
                        destination.imageIndex = Index
                    }
                }
                
            }else if segue.identifier == "availableServiceDays" { //popover
                if let vc = segue.destinationViewController as? AvailableServiceDaysVC {
                    vc.delegate = self
                    vc.modalInPopover = true
                    vc.provider = false
                    vc.availableDays = [1 , 2 , 3]
                    if let controller = vc.popoverPresentationController {
                        controller.delegate = self
                        let height = (navigationController?.navigationBar.frame.height)! + UIApplication.sharedApplication().statusBarFrame.height
                        controller.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), height,0,0)
                        controller.passthroughViews = nil
                        //set it to zero or remove arrow
                        controller.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 1)
                    }
                }
            }
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if daySelected {
            return daysTime[availableServiceDays[0]]
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.WorkingHoursTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! WorkingHoursCell
        cell.WorkingHoursLabel.text = "\(availableHours[availableServiceDays[0]][indexPath.row])"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedTimeIndex = indexPath.row
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
    }
}

