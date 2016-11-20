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
    func shouldDismissDaysView(_ days: [Int])
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
            selectAllDaysButton.isHidden = true
            saveButton.isHidden = true
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
    @IBAction func selectDeselectAllDaysButtonPressed(_ sender: UIButton) {
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
                let rowToSelect:IndexPath = IndexPath(row: index, section: 0)
                //add checkmark next to selected row
                tableView.cellForRow(at: rowToSelect)?.accessoryType = .checkmark
            }
            allSelected = true
            sender.setTitle("Deselect All Days", for: UIControlState())
        }else {
            for index in 0..<daysString.count {
                days.remove(at: 0) //remove all selected days from the array
                //remove checkmark next to selected row
                let rowToSelect: IndexPath = IndexPath(row: index, section: 0)
                tableView.cellForRow(at: rowToSelect)?.accessoryType = .none
            }
            allSelected = false
            sender.setTitle("Select All Days", for: UIControlState())
        }
    }

    //MARK: TableView Delegate functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysString.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let myCell = tableView.dequeueReusableCell(withIdentifier: CellID) {
            myCell.textLabel?.text = "\(daysString[indexPath.row])"
            myCell.selectionStyle = .none
            if !availableDays.contains(indexPath.row){
               myCell.textLabel?.textColor = UIColor.gray
            }
            return myCell
        }else {
            let myCell = UITableViewCell(style: .default, reuseIdentifier: CellID)
            myCell.textLabel?.text = "\(daysString[indexPath.row])"
            myCell.selectionStyle = .none
            if !availableDays.contains(indexPath.row){
               myCell.textLabel?.textColor = UIColor.gray
            }
            return myCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if !availableDays.contains(indexPath.row){
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        days.append(indexPath.row)
        days.sort() { $0 < $1 }
        if !provider {
            delegate?.shouldDismissDaysView(days)
            self.navigationController?.popViewController(animated: true)
        }
        //add checkmark next to selected row
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        days = days.filter() { $0 != indexPath.row }
        //remove checkmark next to selected row
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
