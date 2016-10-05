//
//  OfferedServiceDetailsP.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 9/20/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class OfferedServiceDetailsP: UIViewController, UITableViewDelegate, UITableViewDataSource, iCarouselDelegate, iCarouselDataSource {

    //MARK: IBOutlets
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var picturesView: iCarousel!
    @IBOutlet weak var tableView: UITableView! //cell height = 45
    @IBOutlet weak var availableServiceDaysLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: Vaiables
    var CellID = "timeCell"
    var timeData = [1,2,3,4,5,67,8,8]
    var serviceImages = [UIImage]()
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        adjustContentViewHeight()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        setupTableViewHeight()
    }
    
    //MARK: Functions
    func setup() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.whiteColor()
        setupNavigationBar()
        setupTableView()
        
        picturesView.delegate = self
        picturesView.dataSource = self
        picturesView.type = .Linear
        picturesView .reloadData()
        picturesView.clipsToBounds = true
        
        //TODO: DELETE THIS
        serviceImages.append(UIImage(named: "profileImagePlaceholder")!)
        serviceImages.append(UIImage(named: "profileImagePlaceholder")!)
        serviceImages.append(UIImage(named: "profileImagePlaceholder")!)
        picturesView.reloadData()
    }
    func setupTableViewHeight() {
        tableViewHeight.constant = 45 * CGFloat(timeData.count)
    }
    func setupNavigationBar() {
        navigationItem.title = "Service Title"
        let editBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(editService))
        navigationItem.rightBarButtonItem = editBarButtonItem
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        tableView.rowHeight = 45
    }
    func editService() {
        print("will edit this offered service")
    }
    func adjustContentViewHeight() {
        var contentRect = CGRectZero
        for view in containerView.subviews {
            contentRect = CGRectUnion(contentRect, view.frame)
        }
        containerViewHeight.constant = contentRect.size.height+20
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID)
        cell?.textLabel?.text = "\(timeData[indexPath.row])"
        cell?.selectionStyle  = .None
        return cell!
    }
    
    //MARK: iCarousel Delegate Function (for services images)
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return serviceImages.count
    }
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        let tempView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        tempView.contentMode = .ScaleAspectFill
        tempView.clipsToBounds = true
        tempView.image = serviceImages[index]
        return tempView
    }
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.Spacing {
            return value*1.1
        }
        return value
    }
    func carousel(carousel: iCarousel, didSelectItemAtIndex index: Int) {
        performSegueWithIdentifier("ImagePreviewVC", sender: index)
    }
    
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let myIndex = sender as? Int
        if segue.identifier == "ImagePreviewVC" {
            if let vc = segue.destinationViewController as? ImagePreview {
                if let index = myIndex {
                    vc.imageIndex = index
                    vc.image = serviceImages[index]
                }
                
            }
        }
    }
}
