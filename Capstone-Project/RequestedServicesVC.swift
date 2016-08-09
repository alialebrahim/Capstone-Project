//
//  RequestedServicesVC.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/26/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class RequestedServicesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Variables
    var requestedServices = [String]()
    var CellID = "RequestedServiceCell"
    
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
        return 10
        //return requestedServices.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID)
        return cell!
    }
    
    //MARK: Functions
    func setupTableView() {
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "RequestedServiceCell", bundle: nil), forCellReuseIdentifier: CellID)
        tableView.rowHeight = 173
    }
    func configureNavigationBar() {
        
        self.navigationItem.title = "Requested Services"
        self.navigationController?.view.backgroundColor = UIColor.whiteColor() //because it had a darker color
    }
    
    
}
