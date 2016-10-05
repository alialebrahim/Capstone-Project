//
//  Feed.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 9/12/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class Feed: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    var publicServices = [1,2,3,4,5,7,7]
    var bids = [7,21,322]
    let sections = ["You Bid On","Public Services"]
    let CellID = "PublicCell"
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Functions
    func setup() {
        automaticallyAdjustsScrollViewInsets = false
        setupTableView()
        setupNavigationBar()
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "PublicServiceCell", bundle: nil), forCellReuseIdentifier: CellID)
    }
    func setupNavigationBar() {
        navigationItem.title = "Feed"
    }
    //MARK: TableView delegate functions
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return bids.count
        }else {
            return publicServices.count
        }
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }else {
            return 250
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("PublicServiceDetails", sender: nil)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCellWithIdentifier("test") {
                cell.textLabel?.text = "\(bids[indexPath.row])"
                return cell
            }else {
                let cell = UITableViewCell(style: .Default, reuseIdentifier: "test")
                cell.textLabel?.text = "\(bids[indexPath.row])"
                return cell
            }
            
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier(CellID)
            return cell!
        }
        
    }
}
