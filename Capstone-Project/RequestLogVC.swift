//
//  RequestLogVC.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 9/12/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RequestLogVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let CellID = "SeekerLogCell"
    let defaults = UserDefaults.standard
    var data = [1,2,3,4,5,67]
    var logJSON: JSON?
    var logObjects = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getFeed()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setup() {
        automaticallyAdjustsScrollViewInsets = false
        setupNavigationBar()
        setupTableView()
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nibFile = UINib(nibName: "seekerLogCell", bundle: nil)
        tableView.register(nibFile, forCellReuseIdentifier: CellID)
        tableView.rowHeight = 200
    }
    func setupNavigationBar() {
        navigationItem.title = "Request Log"
    }
    func submitPublicService() {
        performSegue(withIdentifier: "SubmitPublicService", sender: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logObjects.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID) as? ServiceLogCell
        let service = logObjects[indexPath.row]
        
        if let myService = service as? OfferedServiceModel {
            cell?.title.text = myService.title
            cell?.status.text = "Status: "+myService.status!
            cell?.provider.setTitle(myService.provider!, for: .normal)
            cell?.provider.isEnabled = false
            cell?.provider.setTitleColor(UIColor.darkText, for: .normal)
            cell?.timeCreated.text = myService.created!
            cell?.timeDone.text = "Due to: -"
        }else if let myService = service as? specialServiceModel{
            cell?.title.text = myService.title
            cell?.status.text = "Status: "+myService.status!
            cell?.provider.setTitle(myService.provider!, for: .normal)
            cell?.provider.isEnabled = false
            cell?.provider.setTitleColor(UIColor.darkText, for: .normal)
            cell?.timeCreated.text = myService.created!
            if let due = myService.dueDate {
                cell?.timeDone.text = "Due to: "+due
            }else {
                cell?.timeDone.text = "Due to: -"
            }
        }else if let myService = service as? PublicServiceModel {
            cell?.title.text = myService.title
            cell?.status.text = "Status: "+myService.status!
            if let provider = myService.provider {
                cell?.provider.setTitle(provider, for: .normal)
            }else {
                cell?.provider.setTitle("-", for: .normal)
            }
            cell?.provider.isEnabled = false
            cell?.provider.setTitleColor(UIColor.darkText, for: .normal)
            cell?.timeCreated.text = myService.created!
            if let due = myService.dueDate {
                cell?.timeDone.text = "Due to: "+due
            }else {
                cell?.timeDone.text = "Due to: -"
            }
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let service = logObjects[indexPath.row]
        if let myService = service as? OfferedServiceModel {
            
            let storyboard = UIStoryboard(name: "Provider", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "offeredDetails") as! OfferedServiceDetailsP
            vc.serviceID = myService.id!
            vc.isSeeker = true
            navigationController?.pushViewController(vc, animated: true)
            
        }else if let myService = service as? specialServiceModel{
            let storyboard = UIStoryboard(name: "Provider", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "PublicServiceVC") as? PublicServiceViewController {
                vc.withBid = false
                print(myService.status)
                vc.mySpecialService = myService
                vc.userType = "seeker"
                vc.isSpecial = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if let myService = service as? PublicServiceModel {
            let storyboard = UIStoryboard(name: "Provider", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "PublicServiceVC") as? PublicServiceViewController {
                vc.withBid = false
                print(myService.status)
                vc.myService = myService
                vc.userType = "seeker"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
    }
    func alertWithMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    func jsonIntoArrayOfLogObjects() {
        logObjects = [logModal]()
        /*Public services that the provider bids on*/
        if let myLog = logJSON {
            for index in 0..<myLog.count {
                if myLog[index]["type"].string == "offered" {
                    let title = myLog[index]["service"]["title"].string
                    let description = myLog[index]["service"]["description"].string
                    let category = myLog[index]["category"].string
                    let price = myLog[index]["service"]["price"].float
                    let id = myLog[index]["id"].int
                    //TODO: apply type safety
                    let service = OfferedServiceModel(category: category!, price: price!, title: title!, description: description!, id: id!)
                    service.idd = myLog[index]["service"]["id"].int
                    service.status = myLog[index]["service"]["status"].string
                    service.created = myLog[index]["service"]["created"].string
                    service.provider = myLog[index]["provider"].string
                    logObjects.append(service)
                }else if myLog[index]["type"].string == "public" {
                    var bidding = [Bid]()
                    for myIndex in 0..<myLog[index]["bid_set"].count {
                        let providerBid = myLog[index]["bid_set"][myIndex]["bid"].int
                        let bidder = myLog[index]["bid_set"][myIndex]["bidder"].int
                        let id = myLog[index]["bid_set"][myIndex]["id"].int
                        let username = myLog[index]["bid_set"][myIndex]["username"].string
                        let myBid = Bid(bid: providerBid!, bidder: bidder!, id: id!, username: username!)
                        bidding.append(myBid)
                        
                    }
                    let category = myLog[index]["category"].string
                    let description = myLog[index]["service"]["description"].string
                    let price = myLog[index]["service"]["price"].float
                    let title = myLog[index]["service"]["title"].string
                    //TODO: use due date
                    //ADD CREATED DATE
                    let dueData = myLog[index]["service"]["due_date"].string
                    let id = myLog[index]["id"].int
                    //TODO: apply type safety
                    let service = PublicServiceModel(category: category!, price: price!, title: title!, description: description!, id: id!,due: dueData, bidding: bidding)
                    service.idd = myLog["public"][index]["service"]["id"].int
                    service.status = myLog[index]["service"]["status"].string
                    service.created = myLog[index]["service"]["created"].string
                    service.provider = myLog[index]["provider"].string
                    service.dueDate = myLog[index]["service"]["due_date"].string
                    logObjects.append(service)
                }else if myLog[index]["type"].string == "special" {
                    let title = myLog[index]["title"].string
                    let description = myLog[index]["description"].string
                    let price = myLog[index]["price"].float
                    let id = myLog[index]["id"].int
                    //TODO: apply type safety
                    let service = specialServiceModel(price: price!, title: title!, description: description!, id: id!, due: nil)
                    service.provider = myLog[index]["provider"].string
                    service.created = myLog[index]["created"].string
                    service.status = myLog[index]["status"].string
                    service.dueDate = myLog[index]["due_to"].string
                    logObjects.append(service)
                }
            }
        }
        
    }
    func getFeed() {
        let URL = "\(AppDelegate.URL)/log/"
        if let myToken = defaults.object(forKey: "userToken") as? String{
            print(myToken)
            let headers = [
                "Authorization": myToken
            ]
            
            Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
                if let myResponse = response.response {
                    print("request")
                    print(response.request!)  // original URL request
                    print("response")
                    print(response.response!) // URL response
                    print("data")
                    print(response.data!)     // server data
                    print("result")
                    print(response.result)   // result of response serialization
                    //if myResponse.statusCode == 200 {
                        if let json = response.result.value {
                            print("my json")
                            print(json)
                            self.logObjects = []
                            self.logJSON = JSON(json)
                            self.jsonIntoArrayOfLogObjects()
                            self.tableView.reloadData()
                        }
                    //}else {
                    //    self.alertWithMessage("Could not load Log information, please try again")
                    //}
                }
            })
        }

    }

}
