//
//  ChooseRatingVC.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 8/16/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Cosmos

protocol ChooseRatingVCDelegate: class {
    func didSelectRating(rating: Int)
}

class ChooseRatingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    let CellID = "RatingCell"
    var delegate: ChooseRatingVCDelegate?
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    //MARK: TableViewDelegate functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID) as? RatingCell
        cell?.rating.settings.updateOnTouch = false
        cell?.rating.settings.fillMode = .Full
        cell?.rating.rating = Double(5) - Double(indexPath.row)
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rating = 5-indexPath.row
        delegate?.didSelectRating(rating)
        navigationController?.popViewControllerAnimated(true)
    }
    //MARK: Functions
    func setup() {
        automaticallyAdjustsScrollViewInsets = false
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "RatingCell", bundle: nil), forCellReuseIdentifier: CellID)
    }
}
