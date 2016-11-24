//
//  PredefinedService.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 6/25/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol OfferedServicesDelegate: class{
    func didSwipeRight()
}
class OfferedServicesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    let defaults = UserDefaults.standard
    let cellID = "ServiceCell"
    let cellSpacingHeight: CGFloat = 10
    var providersPK: Int?
    weak var delegate: OfferedServicesDelegate?
    let addServiceLabel: UILabel = {
        let label = UILabel()
        label.text = "Click '+' to add new services"
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    var tableData = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
    lazy var refreshControl = UIRefreshControl()
    var servicesObject = [OfferedServiceModel]()
    var offeredServices: JSON?
    // MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        congigureNavigationBar()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if tableData.count > 0 {
            if let myView = addServiceLabel.superview {
                if myView == self.view {
                    addServiceLabel.removeFromSuperview()
                    tableView.alwaysBounceVertical = true
                }
            }
//            if (addServiceLabel.superview != nil) == (self.view) {
//                addServiceLabel.removeFromSuperview()
//                tableView.alwaysBounceVertical = true
//            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("im here")
        gettingOfferedService()
        
    }
    
    // MARK: Functions
    func setup() {
        automaticallyAdjustsScrollViewInsets = false
        
        //swipe gesture needed to navigate between tabs for the SEEKER
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action:#selector(rightSwipeAction))
        rightSwipeGesture.direction = .right
        view.addGestureRecognizer(rightSwipeGesture)
        /*if there is no entry create a label to nofify the user to add services*/
        if tableData.count == 0 {
            addMessageLabel()
        }
        
//        let colors = [UIColor(hex: 0xB39DDB), UIColor(hex: 0x7E57C2)]
//        self.view.setGradientBackground(colors)
        self.view.backgroundColor = UIColor.white
    }
    func congigureNavigationBar() {
        navigationItem.title = "Offered Services"
        
        let addBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addService))
        
        navigationItem.rightBarButtonItem = addBarItem
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        //register the cell xib file for this tableview
        tableView.register(UINib(nibName: "predefinedServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        tableView.rowHeight = 129
        tableView.separatorStyle = .none
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSForegroundColorAttributeName: UIColor(hex:0x404040)])
        refreshControl.tintColor = UIColor(hex: 0x404040)
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    func animateTableViewCells() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for myCell in cells {
            let cell: UITableViewCell = myCell as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
                }, completion: nil)
            
            index += 1
        }
    }
    func addService() {
        print("adding a service")
        performSegue(withIdentifier: "addPredefinedServiceVC", sender: self)
    }
    func addMessageLabel() {
        view.addSubview(addServiceLabel)
        tableView.alwaysBounceVertical = false
        //center addServiceLabel in its superview
        addServiceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addServiceLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        addServiceLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    //handing tableview refreshing
    func refreshTableView() {
        print("refreshing")
        //do whatever needed to update tableview
        //then use
        //tableView.reloadData()
        //refreshControl.endRefreshing()
    }
    func rightSwipeAction() {
        delegate?.didSwipeRight()
    }
    
    //MARK: TableView Delegate Functions.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicesObject.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PredefinedServicesCell
        
        //Configure cell
        var service: OfferedServiceModel!
        service = servicesObject[indexPath.row]
        //Cell configuration.
        myCell.serviceTitle.text = service.title
        myCell.servicePrice.text = "\(service.price)"
        myCell.serviceCurrency.text = "KWD"
//        myCell.priceView.backgroundColor = UIColor(hex: 0xa85783)
        myCell.serviceDescription.text = service.description
        return myCell
//        myCell.servicePrice.text = "\(tableData[indexPath.row])"
//        myCell.serviceCurrency.text = "KWD"
//        myCell.serviceTitle.text = "Building iOS Application"
//        myCell.serviceDescription.text = "This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description"
//        return myCell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //swipe to delete row
        if editingStyle == .delete {
            let alertControl = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete this service?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (UIAlertAction) in
                tableView.beginUpdates()
                //TODO: BACKEND FUNCTION CALL
                let id = self.servicesObject[indexPath.row].id!
                self.servicesObject.remove(at: indexPath.row)
                self.deleteOfferedService(id)
                self.tableData.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .right)
                tableView.endUpdates()
                tableView.reloadData()
                if self.tableData.isEmpty{
                    self.addMessageLabel()
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertControl.addAction(deleteAction)
            alertControl.addAction(cancelAction)
            
            present(alertControl, animated: true, completion: nil)
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //serviceID = indexPath.row
        var service: OfferedServiceModel!
        service = servicesObject[indexPath.row]
        let id = service.id!
        performSegue(withIdentifier: "OfferedServiceDetails", sender: id)
    }
    //MARK: Functions
    func alertWithMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    func jsonIntoArrayOfObjects() {
        servicesObject = [OfferedServiceModel]()
        if let myOfferedServices = offeredServices {
            for index in 0..<myOfferedServices.count {
                let title = myOfferedServices[index]["service"]["title"].string
                let description = myOfferedServices[index]["service"]["description"].string
                let category = myOfferedServices[index]["category"].string
                let price = myOfferedServices[index]["service"]["price"].float
                let id = myOfferedServices[index]["id"].int
                //TODO: apply type safety
                let service = OfferedServiceModel(category: category!, price: price!, title: title!, description: description!, id: id!)
                servicesObject.append(service)
            }
        }
    }
    //MARK: Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = sender as? Int {
            if segue.identifier == "OfferedServiceDetails" {
                if let vc = segue.destination as? OfferedServiceDetailsP {
                    vc.serviceID = id
                }
            }
        }
    }
    //MARK: BACKEND
    func gettingOfferedService() {
        //TODO: add loading animation only for the first time.
        let URL = "\(AppDelegate.URL)/providerservices/"
        let parameter = [
            "providerpk": 46
        ]
        Alamofire.request(URL, method: .get, parameters: parameter).responseJSON { (response) in
            if let myResponse = response.response {
                if myResponse.statusCode == 200 {
                    if let json = response.result.value {
                        self.offeredServices = JSON(json)
                        self.jsonIntoArrayOfObjects()
                        self.refreshControl.endRefreshing()
                        self.tableView.reloadData()
                        self.animateTableViewCells()
                    }
                }else {
                    self.alertWithMessage("There was a problem getting offered services\n please try again")
                    self.refreshControl.endRefreshing()
                }
            }else {
                self.alertWithMessage("There was a problem getting offered services\n please try again")
                self.refreshControl.endRefreshing()
            }
        }
//        Alamofire.request(.GET, URL, parameters: parameter).responseJSON { response in
//            if let myResponse = response.response {
//                if myResponse.statusCode == 200 {
//                    if let json = response.result.value {
//                        self.offeredServices = JSON(json)
//                        self.jsonIntoArrayOfObjects()
//                        self.refreshControl.endRefreshing()
//                        self.tableView.reloadData()
//                        self.animateTableViewCells()
//                    }
//                }else {
//                    self.alertWithMessage("There was a problem getting offered services\n please try again")
//                    self.refreshControl.endRefreshing()
//                }
//            }else {
//                self.alertWithMessage("There was a problem getting offered services\n please try again")
//              self.refreshControl.endRefreshing()
//            }
//        }
//        
//    }
    }
    ///
    func deleteOfferedService(_ pk: Int) {
        //TODO: add loading animation only for the first time.
        let URL = "\(AppDelegate.URL)/offeredservice/"
        var headers: [String:String]!
        if let myToken = defaults.object(forKey: "userToken") as? String {
            headers = [
                "Authorization": myToken
            ]
        }
        print("PK is \(pk)")
        let parameter = [
            "servicepk": pk
        ]
        Alamofire.request(URL, method: .delete, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if let mydata = String(data: response.data!, encoding: String.Encoding.utf8) {
                print("my data is \(mydata)")
            }
            print(response.request!)
            print(response.response!)
            print(response.result)
            if let myResponse = response.response {
                if myResponse.statusCode == 200 {
                    print("its working")
                }else {
                    self.alertWithMessage("There was a problem deleting offered services\n please try again")
                }
            }else {
                self.alertWithMessage("There is a problem with the server\nPlease try again")
            }
        }
//        Alamofire.request(.DELETE, URL, parameters: parameter,headers: headers, encoding: .json).responseJSON { response in
//            if let mydata = String(data: response.data!, encoding: String.Encoding.utf8) {
//                print("my data is \(mydata)")
//            }
//            print(response.request)
//            print(response.response)
//            print(response.result)
//            if let myResponse = response.response {
//                if myResponse.statusCode == 200 {
//                    print("its working")
//                }else {
//                    self.alertWithMessage("There was a problem deleting offered services\n please try again")
//                }
//            }else {
//                self.alertWithMessage("There is a problem with the server\nPlease try again")
//            }
//        }
        
    }
}

