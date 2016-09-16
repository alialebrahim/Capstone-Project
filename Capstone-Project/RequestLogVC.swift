//
//  RequestLogVC.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 9/12/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class RequestLogVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let CellID = ""
    /*
     data[0] : public requests
     data[1] : being working on
     data[2] : pending requests
     data[3] : History
     */
    var data = [
                ["Margarita", "BBQ Chicken", "Pepperoni"],
                ["sausage", "meat lovers", "veggie lovers"],
                ["sausage", "chicken pesto", "prawns", "mushrooms"]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setup() {
        automaticallyAdjustsScrollViewInsets = false
        setupNavigationBar()
        setupTableView()
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    func setupNavigationBar() {
        navigationItem.title = "Request Log"
    }
    func submitPublicService() {
        performSegueWithIdentifier("SubmitPublicService", sender: nil)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
        //return data[section].count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID)
        return cell!
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