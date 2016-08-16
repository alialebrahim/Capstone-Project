//
//  ProvidersSearchVC.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 8/16/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class ProvidersSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    //MARK: Variables
    let CellID = "ProviderCell"
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
    }
    //MARK: UITableView delegate functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID)
        return cell!
    }
    //MARK: Functions
    func setup(){
        automaticallyAdjustsScrollViewInsets = false
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "ProviderCell", bundle: nil), forCellReuseIdentifier: CellID)
        tableView.rowHeight = 137
    }
}
