//
//  PredefinedService.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 6/25/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

protocol PredefinedServicesDelegate {
    func didSwipeRight()
}
class PredefinedServicesVC: UITableViewController {
    
    //MARK: Variables
    let cellID = "ServiceCell"
    let cellSpacingHeight: CGFloat = 10
    var delegate: PredefinedServicesDelegate?
    let addServiceLabel: UILabel = {
        let label = UILabel()
        label.text = "Click '+' to add new services"
        label.textColor = UIColor.lightGrayColor()
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    var tableData = [Int]()//["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
    var serviceID = -2
    
    // MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
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
        
        //swipe gesture needed to navigate between tabs
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action:#selector(PredefinedServicesVC.rightSwipeAction))
        rightSwipeGesture.direction = .Right
        view.addGestureRecognizer(rightSwipeGesture)
        /*if there is no entry create a label to nofify the user to add services*/
        if tableData.count == 0 {
            addMessageLabel()
        }
    }
    func setupTableView() {
        
        //register the cell xib file for this tableview
        tableView.registerNib(UINib(nibName: "predefinedServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        tableView.rowHeight = 129
        //setting refresh controller
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(PredefinedServicesVC.refreshTableView), forControlEvents: .ValueChanged)
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
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! PredefinedServicesCell
        
        //Configure cell
        myCell.servicePrice.text = "\(tableData[indexPath.row])"
        myCell.serviceCurrency.text = "KWD"
        myCell.serviceTitle.text = "Building iOS Application"
        myCell.serviceDescription.text = "This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description"
        return myCell
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //swipe to delete row
        if editingStyle == .Delete {
            tableView.beginUpdates()
            tableData.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
            tableView.endUpdates()
            if tableData.isEmpty{
                addMessageLabel()
            }
        }
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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

