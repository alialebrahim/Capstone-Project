//
//  RequestedServicesVC.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/26/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WorkingOnVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Variables
    var requestedServices = [String]()
    var CellID = "WorkingOnServiceCell"
    let defaults = UserDefaults.standard
    lazy var refreshControl = UIRefreshControl()
    var requestsJSON: JSON?
    var services = [AnyObject]()
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myRequests()
    }
    //MARK: Tableview delegate functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let myService = services[indexPath.row] as? OfferedServiceModel {
            let storyboard = UIStoryboard(name: "Provider", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "offeredDetails") as! OfferedServiceDetailsP
            vc.serviceID = myService.id!
            navigationController?.pushViewController(vc, animated: true)
        }else if let myService = services[indexPath.row] as? specialServiceModel{
            let storyboard = UIStoryboard(name: "Provider", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PublicServiceVC") as! PublicServiceViewController
            vc.mySpecialService = myService
            vc.isSpecial = true
            navigationController?.pushViewController(vc, animated: true)
        }else if let myService = services[indexPath.row] as? PublicServiceModel {
            let storyboard = UIStoryboard(name: "Provider", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PublicServiceVC") as! PublicServiceViewController
            vc.myService = myService
            vc.fromWorkingon = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID) as? WorkingOnServiceCell
        let service = services[indexPath.row]
        if let myService = service as? OfferedServiceModel {
            cell?.titleLabel.text = myService.title
            cell?.seekerUsernameButton.isEnabled = false
            cell?.seekerUsernameButton.setTitle(myService.seeker!, for: .normal)
            cell?.requestedOnLabel.text = "Requested On: "+myService.created!
            cell?.statusLabel.text = "Status: "+myService.status!
            cell?.dueToLabel.text = "Due to: -"
        }else if let myService = service as? specialServiceModel{
            cell?.titleLabel.text = myService.title
            cell?.seekerUsernameButton.isEnabled = false
            cell?.seekerUsernameButton.setTitle(myService.seeker!, for: .normal)
            cell?.requestedOnLabel.text = "Requested On: "+myService.created!
            cell?.statusLabel.text = "Status: "+myService.status!
            if let due = myService.dueDate {
                cell?.dueToLabel.text = "Due to: "+due
            }else {
                cell?.dueToLabel.text = "Due to: -"
            }
        }else if let myService = service as? PublicServiceModel {
            cell?.titleLabel.text = myService.title
            cell?.seekerUsernameButton.isEnabled = false
            cell?.seekerUsernameButton.setTitle(myService.seeker!, for: .normal)
            cell?.requestedOnLabel.text = "Requested On: "+myService.created!
            cell?.statusLabel.text = "Status: "+myService.status!
            if let due = myService.dueDate {
                cell?.dueToLabel.text = "Due to: "+due
            }else {
                cell?.dueToLabel.text = "Due to: -"
            }
        }
        //CONFIGURE CELL
//        cell?.titleLabel.text = "\(data[indexPath.row])"
        return cell!
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let done = UITableViewRowAction(style: .normal, title: "Done") { action, index in

            let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you want to mark this service as \"Done\"?  \nMarking this service \"Done\" the seeker will get the confirmation", preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Done", style: .destructive, handler: { (UIAlertAction) in
                //TODO: BACKEND STUFF
                self.tableView.beginUpdates()
                var id: Int!
                if let myService = self.services[indexPath.row] as? OfferedServiceModel {
                    id = myService.idd
                    self.doneTheService(id)
                }else if let myService = self.services[indexPath.row] as? specialServiceModel{
                    id = myService.id!
                    self.doneTheService(id)
                }else if let myService = self.services[indexPath.row] as? PublicServiceModel {
                    id = myService.idd
                    self.doneTheService(id)
                }
                self.services.remove(at: indexPath.row)
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
        myRequests()
        //do whatever needed to update tableview
        //then use
        //tableView.reloadData()
        //refreshControl.endRefreshing()
    }
    func alertWithMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    func jsonIntoArrayOffered() {
        if let myOfferedServices = requestsJSON {
            for index in 0..<myOfferedServices["offered"].count {
                let title = myOfferedServices["offered"][index]["service"]["title"].string
                let description = myOfferedServices["offered"][index]["service"]["description"].string
                let category = myOfferedServices["offered"][index]["category"].string
                let price = myOfferedServices["offered"][index]["service"]["price"].float
                let id = myOfferedServices["offered"][index]["id"].int
                //TODO: apply type safety
                let service = OfferedServiceModel(category: category!, price: price!, title: title!, description: description!, id: id!)
                service.idd = myOfferedServices["offered"][index]["service"]["id"].int
                service.created = myOfferedServices["offered"][index]["service"]["created"].string
                service.seeker = myOfferedServices["offered"][index]["seeker_username"].string
                service.status = myOfferedServices["offered"][index]["service"]["status"].string
                services.append(service)
            }
        }
    }
    func jsonIntoArraySpecial() {
        if let special = requestsJSON {
            for index in 0..<special["special"].count {
                let title = special["special"][index]["title"].string
                let description = special["special"][index]["description"].string
                let price = special["special"][index]["price"].float
                let id = special["special"][index]["id"].int
                //TODO: apply type safety
                let service = specialServiceModel(price: price!, title: title!, description: description!, id: id!, due: nil)
                service.seeker = special["special"][index]["seeker_username"].string
                service.created = special["special"][index]["created"].string
                service.status = special["special"][index]["status"].string
                service.dueDate = special["special"][index]["due_date"].string
                services.append(service)
            }
        }
    }
    func jsonIntoArrayPublic() {
       
        if let publicService = requestsJSON {
            for index in 0..<publicService["public"].count {
                var bidding = [Bid]()
                for myIndex in 0..<publicService["public"][index]["bid_set"].count {
                    let providerBid = publicService["public"][index]["bid_set"][myIndex]["bid"].int
                    let bidder = publicService["public"][index]["bid_set"][myIndex]["bidder"].int
                    let id = publicService["public"][index]["bid_set"][myIndex]["id"].int
                    let username = publicService["public"][index]["bid_set"][myIndex]["username"].string
                    let myBid = Bid(bid: providerBid!, bidder: bidder!, id: id!, username: "")
                    let status = publicService["public"][index]["bid_set"][myIndex]["status"].string
                    myBid.status = status
                    bidding.append(myBid)
                    
                }
                let category = publicService["public"][index]["category"].string
                let description = publicService["public"][index]["service"]["description"].string
                let price = publicService["public"][index]["service"]["price"].float
                let title = publicService["public"][index]["service"]["title"].string
                //TODO: use due date
                //ADD CREATED DATE
                let dueData = publicService["public"][index]["service"]["due_date"].string
                let id = publicService["public"][index]["id"].int
                //TODO: apply type safety
                let service = PublicServiceModel(category: category!, price: price!, title: title!, description: description!, id: id!,due: dueData, bidding: bidding)
                service.idd = publicService["public"][index]["service"]["id"].int
                service.seeker = publicService["public"][index]["seeker_username"].string
                service.created = publicService["public"][index]["service"]["created"].string
                service.status = publicService["public"][index]["service"]["status"].string
                //service.dueDate = publicService["public"][index]["service"]["due_date"].string
                services.append(service)
                
            }
        }
    }
    
    //MARK: BACKEND
    func acceptDeclineRequest(_ id: Int, response: String) {
        //TODO: add loading animation only for the first time.
        let URL = "\(AppDelegate.URL)/providerresponse/"
        if let myToken = defaults.object(forKey: "userToken") as? String{
            let headers = [
                "Authorization": myToken
            ]
            let parameters = [
                "pk": id,
                "response": response
                ] as [String : Any]
            print(myToken)
            Alamofire.request(URL, method: .post, parameters: parameters, headers: headers).responseJSON(completionHandler: { (response) in
                print("request")
                print(response.request!)  // original URL request
                print("response")
                print(response.response!) // URL response
                print("data")
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print(json!)
                }
                print("result")
                print(response.result)   // result of response serialization
                if let myResponse = response.response {
                    if myResponse.statusCode == 200 {
                        
                    }else {
                        self.alertWithMessage("There was a problem accpeting/declining\n please try again")
                        //self.refreshControl.endRefreshing()
                    }
                }else {
                    self.alertWithMessage("There was a problem requesting the server\n please try again")
                    //self.refreshControl.endRefreshing()
                }
                
            })
        }
        
    }
    func doneTheService(_ servicePK: Int) {
        //TODO: add loading animation only for the first time.
        let URL = "\(AppDelegate.URL)/providerdone/"
        if let myToken = defaults.object(forKey: "userToken") as? String{
            let headers = [
                "Authorization": myToken
            ]
            let parameters = [
                "pk": servicePK
            ]
            print(myToken)
            Alamofire.request(URL, method: .post, parameters: parameters, headers: headers).responseJSON(completionHandler: { (response) in
                print("request")
                print(response.request!)  // original URL request
                print("response")
                print(response.response!) // URL response
                print("data")
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print(json!)
                }
                print("result")
                print(response.result)   // result of response serialization
                if let myResponse = response.response {
                    if myResponse.statusCode == 200 {
                        if let json = response.result.value {
                            print(json)
                        }
                    }else {
                        self.alertWithMessage("There was a problem done the service")
                        //self.refreshControl.endRefreshing()
                    }
                }else {
                    self.alertWithMessage("There was a problem connecting to the server\n please try again")
                    //self.refreshControl.endRefreshing()
                }
                
            })
        }
        
    }
    func myRequests() {
        //TODO: add loading animation only for the first time.
        let URL = "\(AppDelegate.URL)/provider/workingon/"
        if let myToken = defaults.object(forKey: "userToken") as? String{
            let headers = [
                "Authorization": myToken
            ]
            print(myToken)
            Alamofire.request(URL, method: .get, parameters: nil, headers: headers).responseJSON(completionHandler: { (response) in
                print("request")
                print(response.request!)  // original URL request
                print("response")
                print(response.response!) // URL response
                print("data")
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print(json!)
                }
                print("result")
                print(response.result)   // result of response serialization
                if let myResponse = response.response {
                    if myResponse.statusCode == 200 {
                        if let json = response.result.value {
                            print(json)
                            self.services = []
                            self.requestsJSON = JSON(json)
                            self.jsonIntoArrayOffered()
                            self.jsonIntoArraySpecial()
                            self.jsonIntoArrayPublic()
                            self.tableView.reloadData()
                        }
                        self.refreshControl.endRefreshing()
                    }else {
                        self.alertWithMessage("There was a problem getting working on services\n please try again")
                        self.refreshControl.endRefreshing()
                    }
                }else {
                    self.alertWithMessage("There was a problem connecting to the server\n please try again")
                    self.refreshControl.endRefreshing()
                }
                
            })
        }
        
    }
}
