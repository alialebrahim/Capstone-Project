//
//  RequestedServicesVC.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/26/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class WorkingOnVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Variables
    var requestedServices = [String]()
    var CellID = "WorkingOnServiceCell"
    lazy var refreshControl = UIRefreshControl()
    var data = [0,1,2,3,4,5,6,7,8,9,10]
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configureNavigationBar()
    }
    
    
    //MARK: Tableview delegate functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID) as? WorkingOnServiceCell
        cell?.titleLabel.text = "\(data[indexPath.row])"
        return cell!
    }
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let done = UITableViewRowAction(style: .Normal, title: "Done") { action, index in

            let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you want to mark this service as \"Done\"?  \nMarking this service \"Done\" the seeker will get the confirmation", preferredStyle: .Alert)
            let doneAction = UIAlertAction(title: "Done", style: .Destructive, handler: { (UIAlertAction) in
                //TODO: mark this service as done and delete this
                self.tableView.beginUpdates()
                self.data.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.tableView.reloadData()
                self.tableView.endUpdates()
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            alertController.addAction(doneAction)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        done.backgroundColor = UIColor(hex: 0x009900)
        
        return [done]
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    //MARK: Functions
    func setupTableView() {
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "WorkingOnServiceCell", bundle: nil), forCellReuseIdentifier: CellID)
        tableView.rowHeight = 173
        
        //add refresh controller programmativcally.
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshTableView), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    func refreshTableView() {
        print("refreshing tableview")
        //do whatever needed to update tableview
        //then use
        //tableView.reloadData()
        //refreshControl.endRefreshing()
    }
    func configureNavigationBar() {
        
        self.navigationItem.title = "Requested Services"
        self.navigationController?.view.backgroundColor = UIColor.whiteColor() //because it had a darker color
    }
    
    
}
