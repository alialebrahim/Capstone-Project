//
//  ShowBids.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 12/24/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ShowBids: UITableViewController {
    var myService: PublicServiceModel!
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let bids = myService.bids {
            return bids.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("im here !!!!!!!!!!!!!!!!!")
        //let cell = tableView.dequeueReusableCell(withIdentifier: "bidDetail", for: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "bidDetail")!
        cell.textLabel?.text = myService.bids?[indexPath.row].username
        cell.detailTextLabel?.text = "\(myService.bids![indexPath.row].bid!) KWD"

        return cell
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let done = UITableViewRowAction(style: .normal, title: "✓/✕") { action, index in
            
            let alertController = UIAlertController(title: "Confirmation", message: "Do you want to accept of decline this bid", preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Accept", style: .destructive, handler: { (UIAlertAction) in
                //TODO: BACKEND STUFF
                self.tableView.beginUpdates()
                let pk = self.myService.bids?[indexPath.row].id
                self.acceptBid(pk: pk!)
                self.myService.bids?.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadData()
                self.tableView.endUpdates()
                
            })
            let declineAction = UIAlertAction(title: "Decline", style: .destructive, handler: { (UIAlertAction) in
                //TODO: BACKEND STUFF
                self.tableView.beginUpdates()
                let pk = self.myService.bids?[indexPath.row].id
                self.declineBid(pk: pk!)
                self.myService.bids?.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadData()
                self.tableView.endUpdates()
                
            })
            
            alertController.addAction(doneAction)
            alertController.addAction(declineAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        done.backgroundColor = UIColor(hex: 0x009900)
        
        return [done]
    }
    //MARK: BACKEND
    func acceptBid(pk: Int) {
        let URL = "\(AppDelegate.URL)/acceptbid/"
        if let myToken = defaults.object(forKey: "userToken") as? String{
            
            let headers = [
                "Authorization": myToken
            ]
            let parameters = [
                "pk": pk
            ]
            Alamofire.request(URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
                print("request")
                print(response.request!)  // original URL request
                print("response")
                print(response.response!) // URL response
                print("data")
                print(response.data!)     // server data
                print("result")
                print(response.result)   // result of response serialization
                if let myResponse = response.response {
                    if myResponse.statusCode == 200 {
                        print("its working!!")
                    }
                }
            })
        }
    }
    func declineBid(pk: Int) {
        let URL = "\(AppDelegate.URL)/declinebid/"
        if let myToken = defaults.object(forKey: "userToken") as? String{
            
            let headers = [
                "Authorization": myToken
            ]
            let parameters = [
                "pk": pk
            ]
            Alamofire.request(URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
                print("request")
                print(response.request!)  // original URL request
                print("response")
                print(response.response!) // URL response
                print("data")
                print(response.data!)     // server data
                print("result")
                print(response.result)   // result of response serialization
                if let myResponse = response.response {
                    if myResponse.statusCode == 200 {
                        print("its working!!")
                    }
                }
            })
        }
    }

}
