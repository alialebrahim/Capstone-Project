//
//  DetailedPredefinedServiceVC.swift
//  Khedmat
//
//  Created by Yousif Al-Huwaidi on 7/20/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class DetailedPredefinedServiceVC: UIViewController , UITableViewDelegate , UITableViewDataSource , iCarouselDelegate , iCarouselDataSource {
    
    @IBOutlet weak var ServiceTitleLabel: UILabel!
    @IBOutlet weak var ServiceDescriptionTextView: UITextView!
    @IBOutlet weak var ServicePriceLabel: UILabel!
    @IBOutlet weak var WorkingHoursTableView: UITableView!
    @IBOutlet weak var CarouselView: iCarousel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    var ServiceID = 5 //getting it from server
    var UserType = 0
    var ServiceTitle = "Building iOS Application" //getting it from server

    var ServiceDescription = "This is a service description." //getting it from server
    var ServicePrice = "7 KWD" //getting it from server
    var Images = [UIImage]() //getting it from server
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Images = [UIImage(named: "Image1")! , UIImage(named: "Image2")!]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scrollViewSetting()
    }
    
    override func viewDidLoad() {
        if UserType == 0 {
            let editPredefinedServiceItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self,   action: #selector(DetailedPredefinedServiceVC.editPredefineService))
            self.navigationItem.rightBarButtonItem = editPredefinedServiceItem
        }
        
        
        navigationItem.title = "Service Details"
        LabelsSetting()
        ServiceTitleLabel.text = ServiceTitle
        ServiceDescriptionTextView.text = ServiceDescription
        ServicePriceLabel.text = ServicePrice
    }
    
    
    @IBAction func requestPressed() {
        //request predefined service from the server
        self.navigationController?.popViewControllerAnimated(true)
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
    }
    
    func scrollViewSetting () {
        scrollView.userInteractionEnabled = true
        var contentRect = CGRectZero;
        
        for view in self.contentView.subviews {
            contentRect = CGRectUnion(contentRect, view.frame)
        }
        
        contentViewHeightConstraint.constant = contentRect.size.height + 20
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editPredefinedServiceSegue" {
            if let destination = segue.destinationViewController as? addService {
                destination.serviceID = ServiceID
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
            }
        }
    }
    
    func editPredefineService () {
        performSegueWithIdentifier("editPredefinedServiceSegue", sender: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.WorkingHoursTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! WorkingHoursCell
        cell.WorkingHoursLabel.text = "6 AM to 9 PM"
        return cell
    }
}
