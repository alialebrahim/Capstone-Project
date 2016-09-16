//
//  Categories.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 8/10/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

//MARK: Protocols
protocol CategoriesVCDelegate: class {
    func shouldDismissCategoriesView(categories: [String])
}

//MARK: Enum
enum Categories: String {
    case Cleaning = "Cleaning Services"
    case Food = "Food Services"
    case Errands = "Errands Services"
    case Pet = "Pet Services"
    case RealEstate = "Real Estate Services"
    case Beauty = "Beauty Services"
    case Others = "Others"
}

class CategoriesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: IBOutlets
    @IBOutlet weak var saveCancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    var categories: [Categories] = {
        var categoriesArray = [Categories]()
        categoriesArray.append(.Cleaning)
        categoriesArray.append(.Food)
        categoriesArray.append(.Errands)
        categoriesArray.append(.Pet)
        categoriesArray.append(.RealEstate)
        categoriesArray.append(.Beauty)
        categoriesArray.append(.Others)
        
        return categoriesArray
    }()
    var categoriesString = [String]()
    let CellID = "CategoryCell"
    weak var delegate: CategoriesVCDelegate?
    //MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
    }
    
    //MARK: Functions
    func setup() {
        saveCancelButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        automaticallyAdjustsScrollViewInsets = false
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
    }
    
    //MARK: TableView Delegate functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let myCell = tableView.dequeueReusableCellWithIdentifier(CellID) {
            myCell.selectionStyle = .None
            myCell.textLabel?.text = categories[indexPath.row].rawValue
            return myCell
        }else {
            let myCell = UITableViewCell(style: .Default, reuseIdentifier: CellID)
            myCell.selectionStyle = .None
            myCell.textLabel?.text = categories[indexPath.row].rawValue
            return myCell
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //add checkmark next to selected row
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        categoriesString.append(categories[indexPath.row].rawValue)
        print(categoriesString)
        if categoriesString.count != 0 {
            saveCancelButton.setTitle("Save", forState: .Normal)
        }
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //removing checkmark next to selected row
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
        categoriesString.removeObject(categories[indexPath.row].rawValue)
        print(categoriesString)
        if categoriesString.count == 0 {
            saveCancelButton.setTitle("Cancel", forState: .Normal)
        }
    }
    //MARK: IBActions
    @IBAction func CancelSaveButtonPressed() {
        print("im here")
        delegate?.shouldDismissCategoriesView(categoriesString)
    }
}