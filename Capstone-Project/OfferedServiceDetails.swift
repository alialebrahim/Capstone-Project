//
//  OfferedServiceDetails.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 9/19/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class OfferedServiceDetails: UIViewController, iCarouselDelegate, iCarouselDataSource {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var selectDayButton: UIButton!
    @IBOutlet weak var selectTimeButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    var serviceImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        adjustContentViewHeight()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setup() {
        automaticallyAdjustsScrollViewInsets = false
        navigationBarSetup()
        
        //////
        descriptionTextView.text = "hello"
        priceLabel.text = "10 KWD"
    }
    func navigationBarSetup() {
        navigationItem.title = "Service title"
    }
    func adjustContentViewHeight() {
        print("im here")
        var contentRect = CGRectZero
        for view in containerView.subviews {
            contentRect = CGRectUnion(contentRect, view.frame)
        }
        containerViewHeight.constant = contentRect.size.height+20
    }
    //MARK: iCarousel Delegate function
    //MARK: iCarousel Delegate Function (for services images)
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return pictures.count
    }
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        let tempView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        tempView.contentMode = .ScaleAspectFill
        tempView.clipsToBounds = true
        tempView.image = pictures[index]
        return tempView
    }
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.Spacing {
            return value*1.1
        }
        return value
    }
    func carousel(carousel: iCarousel, didSelectItemAtIndex index: Int) {
        //performSegueWithIdentifier("ImagePreviewVC", sender: index)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
