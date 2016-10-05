//
//  PredefinedService.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 6/25/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Alamofire
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
        animateTableViewCells()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: Functions
    func setup() {
        automaticallyAdjustsScrollViewInsets = false
        
        //swipe gesture needed to navigate between tabs for the SEEKER
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action:#selector(rightSwipeAction))
        rightSwipeGesture.direction = .Right
        view.addGestureRecognizer(rightSwipeGesture)
        /*if there is no entry create a label to nofify the user to add services*/
        if tableData.count == 0 {
            addMessageLabel()
        }
        
        let colors = [UIColor(hex: 0xB39DDB), UIColor(hex: 0x7E57C2)]
        self.view.setGradientBackground(colors)
    }
    func congigureNavigationBar() {
        navigationItem.title = "Offered Services"
        
        let addBarItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addService))
        
        navigationItem.rightBarButtonItem = addBarItem
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
        //register the cell xib file for this tableview
        tableView.registerNib(UINib(nibName: "predefinedServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        tableView.rowHeight = 129
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: #selector(refreshTableView), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    func animateTableViewCells() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for myCell in cells {
            let cell: UITableViewCell = myCell as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
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
                //TODO: BACKEND FUNCTION CALL
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
        //serviceID = indexPath.row
        performSegueWithIdentifier("OfferedServiceDetails", sender: nil)
    }
    //MARK: BACKEND
}

