//
//  AvailableServiceDaysVC.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/25/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

/*
NOTE:
 days are mapped to intergers as follows:
 
 "Saterday" = 0
 "Sunday" = 1
 "Monday" = 2
 "Tuesday" = 3
 "Wednesday" = 4
 "Thursday" = 5
 "Friday" = 6
 
 this mapping is used to map each entry in the daysString entry to its index
 EX:
    adding 0,1,2 to days array means saterday,sunday,monday were selected.
 */

import UIKit
//MARK: Protocol
protocol AvailableServiceDaysDelegate: class {
    func shouldDismissDaysView(days: [Int])
}
class AvailableServiceDaysVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    var days = [Int]()
    var availableDays = [0 , 1 , 2 , 3 , 4 , 5 , 6]
    var provider = true
    var CellID = "DayCell"
    var daysString = ["Saterday","Sunday","Monday","Tuesday","Wednesday","Thursday","Friday"]
    var allSelected = false
    weak var delegate: AvailableServiceDaysDelegate?
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        if !provider {
            selectAllDaysButton.hidden = true
            saveButton.hidden = true
        }
        
    }
    @IBOutlet weak var selectAllDaysButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    //MARK: IBActions
    @IBAction func saveButtonPressed() {
        if !days.isEmpty {
            delegate?.shouldDismissDaysView(days)
        }else {
            //TODO: alert to notify the user to select days
        }
        
    }
    @IBAction func selectDeselectAllDaysButtonPressed(sender: UIButton) {
        /*
            if not all days are selected
                iterate over each day in the daysString array and append its index to days array
                to mark it as selected, in the same time add a checkmark next to cooresponding 
                tableview entry.
                otherwise do the opposite
         */
        if !allSelected {
            days.removeAll()
            for index in 0..<daysString.count {
                days.append(index) //add selected days to the array
                let rowToSelect:NSIndexPath = NSIndexPath(forRow: index, inSection: 0)
                //add checkmark next to selected row
                tableView.cellForRowAtIndexPath(rowToSelect)?.accessoryType = .Checkmark
            }
            allSelected = true
            sender.setTitle("Deselect All Days", forState: .Normal)
        }else {
            for index in 0..<daysString.count {
                days.removeAtIndex(0) //remove all selected days from the array
                //remove checkmark next to selected row
                let rowToSelect: NSIndexPath = NSIndexPath(forRow: index, inSection: 0)
                tableView.cellForRowAtIndexPath(rowToSelect)?.accessoryType = .None
            }
            allSelected = false
            sender.setTitle("Select All Days", forState: .Normal)
        }
    }

    //MARK: TableView Delegate functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysString.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let myCell = tableView.dequeueReusableCellWithIdentifier(CellID) {
            myCell.textLabel?.text = "\(daysString[indexPath.row])"
            myCell.selectionStyle = .None
            if !availableDays.contains(indexPath.row){
               myCell.textLabel?.textColor = UIColor.grayColor()
            }
            return myCell
        }else {
            let myCell = UITableViewCell(style: .Default, reuseIdentifier: CellID)
            myCell.textLabel?.text = "\(daysString[indexPath.row])"
            myCell.selectionStyle = .None
            if !availableDays.contains(indexPath.row){
               myCell.textLabel?.textColor = UIColor.grayColor()
            }
            return myCell
        }
        
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if !availableDays.contains(indexPath.row){
            return false
        }
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        days.append(indexPath.row)
        days.sortInPlace() { $0 < $1 }
        if !provider {
            delegate?.shouldDismissDaysView(days)
            self.navigationController?.popViewControllerAnimated(true)
        }
        //add checkmark next to selected row
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        days = days.filter() { $0 != indexPath.row }
        //remove checkmark next to selected row
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
    }
}
