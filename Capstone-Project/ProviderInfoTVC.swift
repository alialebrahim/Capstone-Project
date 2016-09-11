//
//  ProviderInfoTVC.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 8/23/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class ProviderInfoTVC: UITableViewController {

    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var categoriesTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var areaTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var categoriesCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.scrollEnabled = false
        self.tableView.backgroundColor = UIColor.clearColor()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        print("tableview did load")
        self.tableView.frame.size.height = (44*8) + 75
        //print(tableVewHeight())
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("tableview did appear")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 25))
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        switch section {
            case 0:
                headerLabel.text = "Basic inforamtion"
            case 1:
                headerLabel.text = "Contact infromation"
            case 2:
                headerLabel.text = "Address"
            default : break
        }
        headerLabel.textColor = UIColor.whiteColor()
        headerLabel.backgroundColor = UIColor.clearColor()
        headerView.addSubview(headerLabel)
        headerLabel.leadingAnchor.constraintEqualToAnchor(headerView.leadingAnchor, constant: 5).active = true
        headerLabel.trailingAnchor.constraintEqualToAnchor(headerView.trailingAnchor, constant: 0).active = true
        headerLabel.topAnchor.constraintEqualToAnchor(headerView.topAnchor, constant: 0).active = true
        headerLabel.bottomAnchor.constraintEqualToAnchor(headerView.bottomAnchor, constant: 0).active = true
        headerView.backgroundColor = UIColor(hex: 0xB39DDB, alpha: 0.5)
        return headerView
    }
    
    func setup() {
        
    }

}
