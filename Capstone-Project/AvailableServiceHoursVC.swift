//
//  AvailableServiceHoursVC.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/11/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

//MARK: Protocol
protocol AvailableServiceHoursDelegate: class {
    func shouldDismissHoursView(_ time: [(from: Date, to: Date)])
}
//TODO: how many user can request a service at a spesific time?
class AvailableServiceHoursVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: IBOutlets
    @IBOutlet weak var saveCancelButton: UIButton!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    weak var delegate: AvailableServiceHoursDelegate?
    var availableTimes = [(from: Date,to: Date)]()
    let cellID = "hoursCell"
    var timeFormatter = DateFormatter()
    //var toTime = NSDateFormatter()
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        toDatePicker.datePickerMode = .time
        fromDatePicker.datePickerMode = .time
        //tableview configuration
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        //time objects configuration.
        timeFormatter.timeStyle = .short

    }
    //MARK: IBActions
    @IBAction func addTimeButtonPressed() {
        let fromTime = fromDatePicker.date
        let toTime = toDatePicker.date
        if !TimeIntervalManager.correctTimeInterval(FromTime: fromTime, ToTime: toTime) {
            //TODO: alert to notify the user with the wrong time interval
        }else if TimeIntervalManager.conflicts(TimeIntervalArray: availableTimes as! [(from: NSDate, to: NSDate)], TimeInterval: (fromTime, toTime)) {
            //TODO: alert to notify the user with time conflicts
        }else {
            //if the time given was correct, add it to the array and sort it.
            availableTimes.append((from: fromTime, to: toTime))
            availableTimes.sort { (from1, from2) -> Bool in
                (from1.from as NSDate).earlierDate(from2.from) == from1.from
            }
            tableView.flashScrollIndicators()
            tableView.reloadData()
            saveCancelButton.setTitle("Save", for: UIControlState())
        }
    }
    @IBAction func saveButtonPressed(_ sender: AnyObject) {
        delegate?.shouldDismissHoursView(availableTimes)
    }
    
    //MARK: TableView delegate functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableTimes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let time = availableTimes[indexPath.row]
        let from = timeFormatter.string(from: time.from)
        let to = timeFormatter.string(from: time.to)
        if let myCell = tableView.dequeueReusableCell(withIdentifier: cellID) {
            myCell.textLabel?.text = "from \(from) to \(to)"
            return myCell
        }else {
            let myCell = UITableViewCell(style: .default, reuseIdentifier: cellID)
            myCell.textLabel?.text = "from \(from) to \(to)"
            return myCell
        }
    }
    /*
        swipe to delete a cell
        first delete the data from the array then delete the cell
        this is needed to prevent any error as numberOfRowsInSection will return the length of the array
        if data was not removed from the array, there will be runtime error
     */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            availableTimes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            tableView.endUpdates()
            if availableTimes.count == 0 {
                saveCancelButton.setTitle("Cancel", for: UIControlState())
            }
        }
    }
}
