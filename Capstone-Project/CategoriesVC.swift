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
    func shouldDismissCategoriesView(_ categories: [String])
}

//MARK: Enum
enum Categories: String {
    case Cleaning = "cleaning"
    case Food = "food"
    case Errands = "errands"
    case Pet = "pet"
    case RealEstate = "real estate"
    case Beauty = "beauty"
    case Others = "other"
}

class CategoriesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: IBOutlets
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
    var savedCategory = [String]()
    let CellID = "CategoryCell"
    weak var delegate: CategoriesVCDelegate?
    
    //MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigation()
        setupTableView()
        print("Saved categories are \(savedCategory)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkMarkSavedCategories()
    }
    //MARK: Functions
    func setup() {
        automaticallyAdjustsScrollViewInsets = false
    }
    func setupNavigation() {
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveCategory))
        navigationItem.title = "Category"
        navigationItem.rightBarButtonItem = saveItem

    }
    func saveCategory() {
        delegate?.shouldDismissCategoriesView(categoriesString)
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
    }
    func checkMarkSavedCategories() {
        for category in savedCategory {
            print(category)
            for index in 0..<categories.count {
                let rowToSelect:IndexPath = IndexPath(row: index, section: 0)
                let myCell = tableView.cellForRow(at: rowToSelect)
                print(myCell?.textLabel?.text)
                if let myCategory = myCell?.textLabel?.text {
                    if myCategory == category {
                        myCell?.accessoryType = .checkmark
                        categoriesString.append(myCategory)
                    }
                }
            }
        }
//        days.removeAll()
//        for index in 0..<daysString.count {
//            days.append(index) //add selected days to the array
//            let rowToSelect:NSIndexPath = NSIndexPath(forRow: index, inSection: 0)
//            //add checkmark next to selected row
//            tableView.cellForRowAtIndexPath(rowToSelect)?.accessoryType = .Checkmark
//        }
//        allSelected = true
//        sender.setTitle("Deselect All Days", forState: .Normal)
    }
    //MARK: TableView Delegate functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let myCell = tableView.dequeueReusableCell(withIdentifier: CellID) {
            myCell.selectionStyle = .none
            myCell.textLabel?.text = categories[indexPath.row].rawValue
            return myCell
        }else {
            let myCell = UITableViewCell(style: .default, reuseIdentifier: CellID)
            myCell.selectionStyle = .none
            myCell.textLabel?.text = categories[indexPath.row].rawValue
            return myCell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //add checkmark next to selected row
        if tableView.cellForRow(at: indexPath)?.accessoryType != .checkmark {
            print("checked")
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            categoriesString.append(categories[indexPath.row].rawValue)
            print(categoriesString)
           
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            tableView.cellForRow(at: indexPath)?.isSelected = false
            categoriesString.removeObject(categories[indexPath.row].rawValue)
        }
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //removing checkmark next to selected row
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        categoriesString.removeObject(categories[indexPath.row].rawValue)
        print(categoriesString)
    }
    
}
