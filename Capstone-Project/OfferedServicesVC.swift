//
//  PredefinedService.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 6/25/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

protocol OfferedServicesDelegate: class{
    func didSwipeRight()
}
class OfferedServicesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    //MARK: Variables
    let cellID = "ServiceCell"
    let cellSpacingHeight: CGFloat = 10
    weak var delegate: OfferedServicesDelegate?
    let addServiceLabel: UILabel = {
        let label = UILabel()
        label.text = "Click '+' to add new services"
        label.textColor = UIColor.lightGrayColor()
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    var tableData = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
    lazy var refreshControl = UIRefreshControl()
    
    var serviceID = -2
    
    // MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        congigureNavigationBar()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if tableData.count > 0 {
            if (addServiceLabel.superview != nil) == self.view {
                addServiceLabel.removeFromSuperview()
                tableView.alwaysBounceVertical = true
            }
        }
    }
    // MARK: Functions
    func setup() {
        automaticallyAdjustsScrollViewInsets = false
        
        //swipe gesture needed to navigate between tabs for the seeker
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action:#selector(rightSwipeAction))
        rightSwipeGesture.direction = .Right
        view.addGestureRecognizer(rightSwipeGesture)
        /*if there is no entry create a label to nofify the user to add services*/
        if tableData.count == 0 {
            addMessageLabel()
        }
    }
    func congigureNavigationBar() {
        navigationItem.title = "Offered Services"
        
        let addBarItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addService))
        
        navigationItem.rightBarButtonItem = addBarItem
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        //register the cell xib file for this tableview
        tableView.registerNib(UINib(nibName: "predefinedServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        tableView.rowHeight = 129
        //TODO: refresh controller
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshTableView), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    func addService() {
        print("adding a service")
        performSegueWithIdentifier("addPredefinedServiceVC", sender: self)
    }
    func addMessageLabel() {
        view.addSubview(addServiceLabel)
        tableView.alwaysBounceVertical = false
        //center addServiceLabel in its superview
        addServiceLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        addServiceLabel.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        addServiceLabel.heightAnchor.constraintEqualToConstant(100).active = true
    }
    //handing tableview refreshing
    func refreshTableView() {
        print("refreshing")
        //do whatever needed to update tableview
        //then use
        //tableView.reloadData()
        //refreshControl.endRefreshing()
    }
    func rightSwipeAction() {
        delegate?.didSwipeRight()
    }
    
    //MARK: TableView Delegate Functions.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! PredefinedServicesCell
        
        //Configure cell
        myCell.servicePrice.text = "\(tableData[indexPath.row])"
        myCell.serviceCurrency.text = "KWD"
        myCell.serviceTitle.text = "Building iOS Application"
        myCell.serviceDescription.text = "This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description"
        return myCell
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //swipe to delete row
        if editingStyle == .Delete {
            let alertControl = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete this service?", preferredStyle: .Alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (UIAlertAction) in
                tableView.beginUpdates()
                self.tableData.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
                tableView.endUpdates()
                if self.tableData.isEmpty{
                    self.addMessageLabel()
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertControl.addAction(deleteAction)
            alertControl.addAction(cancelAction)
            
            presentViewController(alertControl, animated: true, completion: nil)
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        serviceID = indexPath.row
        performSegueWithIdentifier("DetailedPredefinedServiceSegue", sender: nil)
    }
    
    //MARK: Segue functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailedPredefinedServiceSegue" {
            if let destination = segue.destinationViewController as? DetailedPredefinedServiceVC {
                destination.ServiceID = serviceID
                destination.UserType = 0
                
            }
        }
    }
    
   
}

