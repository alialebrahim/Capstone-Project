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
    let CellID = "SeekerLogCell"
    var data = [1,2,3,4,5,67]
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
        let nibFile = UINib(nibName: "seekerLogCell", bundle: nil)
        tableView.register(nibFile, forCellReuseIdentifier: CellID)
        tableView.rowHeight = 200
    }
    func setupNavigationBar() {
        navigationItem.title = "Request Log"
    }
    func submitPublicService() {
        performSegue(withIdentifier: "SubmitPublicService", sender: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID)
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
