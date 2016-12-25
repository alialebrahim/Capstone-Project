//
//  Feed.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 9/12/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Feed: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    let defaults = UserDefaults.standard
    //MARK: Variables
    var publicServices = [PublicServiceModel]()
    var providerBidServices = [PublicServiceModel]()
    var bids = [7,21,322]
    let sections = ["You Bid On","Public Services"]
    let CellID = "PublicCell"
    let CellID2 = "PublicBid"
    var publicServicesJSON: JSON?
    var publicServicesWithBids = [Int]()
    var myService: PublicServiceModel!
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPublicServicesInfo()
    }
    //MARK: Functions
    func setup() {
        automaticallyAdjustsScrollViewInsets = false
        setupTableView()
        setupNavigationBar()
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PublicServiceCell", bundle: nil), forCellReuseIdentifier: CellID)
        tableView.register(UINib(nibName: "serviceWithBidCell", bundle: nil), forCellReuseIdentifier: CellID2)
    }
    func setupNavigationBar() {
        navigationItem.title = "Feed"
    }
    //MARK: TableView delegate functions
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return providerBidServices.count
        }else {
            return publicServices.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 106
        }else {
            return 200
        }
    }
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
//        if (section == 0) {
//            headerView.backgroundColor = UIColor(hex:0x404040)
//        } else {
//            headerView.backgroundColor = UIColor.clearColor()
//        }
//        return headerView
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            myService = providerBidServices[indexPath.row]
            performSegue(withIdentifier: "PublicServiceDetails", sender: true)
        }
        if indexPath.section == 1 {
            myService = publicServices[indexPath.row]
            performSegue(withIdentifier: "PublicServiceDetails", sender: false)
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID2) as! serviceWithBidCell
            cell.title.text = "\(providerBidServices[indexPath.row].title))"
            cell.bid.text = "\(providerBidServices[indexPath.row].providerBid!)"
            
            return cell
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID) as! PublicServiceCell
            cell.title.text = publicServices[indexPath.row].title
            cell.info.text = publicServices[indexPath.row].description
            cell.price.text = "\(publicServices[indexPath.row].price)"
            cell.dueTo.text = publicServices[indexPath.row].dueDate
            cell.category.text = publicServices[indexPath.row].category
            return cell
        }
        
    }
    func alertWithMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PublicServiceDetails" {
            if let vc = segue.destination as? PublicServiceViewController {
                //TODO: apply type safety
                vc.myService = myService
                vc.withBid = (sender as? Bool)!
                
            }
        }
    }
    //TODO: Type safety
    func jsonIntoArrayOfPublicObjects() {
        publicServices = [PublicServiceModel]()
        providerBidServices = [PublicServiceModel]()
        if let myPublicService = publicServicesJSON {
            for index in 0..<myPublicService["feed"].count {
                var bidding = [Bid]()
                for myIndex in 0..<myPublicService["feed"][index]["bid_set"].count {
                    let providerBid = myPublicService["feed"][index]["bid_set"][myIndex]["bid"].int
                    let bidder = myPublicService["feed"][index]["bid_set"][myIndex]["bidder"].int
                    let id = myPublicService["feed"][index]["bid_set"][myIndex]["id"].int
                    var myBid: Bid!
                    if let username = myPublicService[index]["bid_set"][myIndex]["username"].string {
                        myBid = Bid(bid: providerBid!, bidder: bidder!, id: id!, username: username)
                    }else {
                        myBid = Bid(bid: providerBid!, bidder: bidder!, id: id!, username: "")
                    }
                    
                    bidding.append(myBid)
                    
                }
                let category = myPublicService["feed"][index]["category"].string
                let description = myPublicService["feed"][index]["service"]["description"].string
                let price = myPublicService["feed"][index]["service"]["price"].float
                let title = myPublicService["feed"][index]["service"]["title"].string
                //TODO: use due date
                //ADD CREATED DATE
                let dueData = myPublicService["feed"][index]["service"]["due_date"].string
                let id = myPublicService["feed"][index]["id"].int
                //TODO: apply type safety
                let service = PublicServiceModel(category: category!, price: price!, title: title!, description: description!, id: id!,due: dueData, bidding: bidding)
                service.status = myPublicService["feed"][index]["service"]["status"].string
                service.created = myPublicService["feed"][index]["service"]["created"].string
                publicServices.append(service)
                
            }
            /*Public services that the provider bids on*/
            for index in 0..<myPublicService["bids"].count {
                var bidding = [Bid]()
                for myIndex in 0..<myPublicService["bids"][index]["bid_set"].count {
                    let providerBid = myPublicService["bids"][index]["bid_set"][myIndex]["bid"].int
                    let bidder = myPublicService["bids"][index]["bid_set"][myIndex]["bidder"].int
                    let id = myPublicService["bids"][index]["bid_set"][myIndex]["id"].int
                    let username = myPublicService["bids"][index]["bid_Set"][myIndex]["username"].string
                    let myBid = Bid(bid: providerBid!, bidder: bidder!, id: id!, username: "")
                    bidding.append(myBid)
                    
                }
                let category = myPublicService["bids"][index]["category"].string
                let description = myPublicService["bids"][index]["service"]["description"].string
                let price = myPublicService["bids"][index]["service"]["price"].float
                let title = myPublicService["bids"][index]["service"]["title"].string
                //TODO: use due date
                let dueDate = myPublicService["bids"][index]["service"]["due_date"].string
                let id = myPublicService["bids"][index]["id"].int
                //TODO: apply type safety
                let service = PublicServiceModel(category: category!, price: price!, title: title!, description: description!, id: id!,due: " ", bidding: bidding)
                let myBid = myPublicService["bids"][index]["bid"].int
                service.providerBid = myBid
                service.status = myPublicService["bids"][index]["service"]["status"].string
                service.created = myPublicService["bids"][index]["service"]["created"].string
                service.dueDate = myPublicService["bids"][index]["service"]["due_date"].string
                providerBidServices.append(service)                
            }
        }
    }
    func jsonIntoArrayOfBidObjects() {
        
    }
    //MARK: BACKEND
    func getPublicServicesInfo() {
        let URL = "\(AppDelegate.URL)/publicservice/"
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
                    if myResponse.statusCode == 200 {
                        if let json = response.result.value {
                            print("my json")
                            print(json)
                            self.publicServicesJSON = JSON(json)
                            self.jsonIntoArrayOfPublicObjects()
                            self.jsonIntoArrayOfBidObjects()
                            self.tableView.reloadData()
                        }
                        //TODO: finish loading animation
                        //                        if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
                        //                            print("my data from getting profile request is \(mydata)")
                        //                        }
                    }else {
                        self.alertWithMessage("Could not load Feed information, please try again")
                    }
                }
            })
        }
    }
}
