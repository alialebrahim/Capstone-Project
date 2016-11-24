//
//  ChooseCategoriesVC.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 8/16/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

protocol ChooseCategoriesVCDelegate: class {
    func didSelectCategory(_ category: String)
}

class ChooseCategoriesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    var cellID = "CategoryCell"
    weak var delegate: ChooseCategoriesVCDelegate?
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        print(categories.count)
        // Do any additional setup after loading the view.
    }

    //MARK: TableView delegate functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell testing")
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        cell?.textLabel?.text = "\(categories[indexPath.row].rawValue)"
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let category = (cell?.textLabel?.text)!
        delegate?.didSelectCategory(category)
        _ = navigationController?.popViewController(animated: true)
    }
    //MARK: Functions
    func setup() {
        automaticallyAdjustsScrollViewInsets = false
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}
