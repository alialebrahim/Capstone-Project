//
//  RequestedServicesVC.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/26/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class WorkingOnVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Variables
    var requestedServices = [String]()
    var CellID = "WorkingOnServiceCell"
    lazy var refreshControl = UIRefreshControl()
    var data = ["Service title","Service title","Service title","Service title","Service title","Service title","Service title","Service title","Service title","Service title","Service title"]
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    //MARK: Tableview delegate functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID) as? WorkingOnServiceCell
        //CONFIGURE CELL
        cell?.titleLabel.text = "\(data[indexPath.row])"
        return cell!
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let done = UITableViewRowAction(style: .normal, title: "Done") { action, index in

            let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you want to mark this service as \"Done\"?  \nMarking this service \"Done\" the seeker will get the confirmation", preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Done", style: .destructive, handler: { (UIAlertAction) in
                //TODO: BACKEND STUFF
                self.tableView.beginUpdates()
                self.data.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadData()
                self.tableView.endUpdates()
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(doneAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        done.backgroundColor = UIColor(hex: 0x009900)
        
        return [done]
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //MARK: Functions
    func setupTableView() {
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "WorkingOnServiceCell", bundle: nil), forCellReuseIdentifier: CellID)
        tableView.rowHeight = 173
        
        //TODO: Chnage color to 404040
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    func refreshTableView() {
        print("refreshing tableview")
        //do whatever needed to update tableview
        //then use
        //tableView.reloadData()
        //refreshControl.endRefreshing()
    }
}
