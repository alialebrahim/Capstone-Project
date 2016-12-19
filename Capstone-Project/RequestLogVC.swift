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
    var logObjects = [logModal]()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID)
        return cell!
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
                /*
                 self.title = title
                 self.status = status
                 self.provider = provider
                 self.seeker = seeker
                 self.type = type
                 */
                let title = myLog[index]["title"].string
                let status = myLog[index]["status"].string
                let provider = myLog[index]["provider"].string
                let seeker = myLog[index]["seeker"].string
                let type = myLog[index]["type"].string
                let id = myLog[index]["id"].int
                
                print(title!)
                print(status!)
                print(provider!)
                print(seeker!)
                print(type!)
                print(id!)
                let logObject = logModal(title: title!, status: status!, provider: provider!, seeker: seeker!, type: type!,id:id!)
                logObjects.append(logObject)
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
            let parameter = [
                "query_last": 5
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
                            //self.logJSON = JSON(json)
                            //self.jsonIntoArrayOfLogObjects()
                            //self.tableView.reloadData()
                        }
                    //}else {
                    //    self.alertWithMessage("Could not load Log information, please try again")
                    //}
                }
            })
        }

    }

}
