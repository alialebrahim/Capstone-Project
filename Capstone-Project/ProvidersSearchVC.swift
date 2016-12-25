//
//  ProvidersSearchVC.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 8/16/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProvidersSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    //MARK: Variables
    let CellID = "ProviderCell"
    var users = [Profile]()
    let defaults = UserDefaults.standard
    var profiles: JSON?
    var category = ""
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchUsers(category)
    }
    //MARK: UITableView delegate functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID) as! ProviderCell
        cell.username.text = users[indexPath.row].username
        cell.about.text = users[indexPath.row].about
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SearchedProvider", sender: indexPath.row)
    }
    //MARK: Functions
    func setup(){
        automaticallyAdjustsScrollViewInsets = false
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProviderCell", bundle: nil), forCellReuseIdentifier: CellID)
        tableView.rowHeight = 137
    }
    func alertWithMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    func jsonIntoArrayOfUsers() {
        users = [Profile]()
        if let usersProfile = profiles {
            for index in 0..<usersProfile.count {
                let username = usersProfile[index]["username"].string
                let category = usersProfile[index]["category"].string
                let about = usersProfile[index]["about"].string
                let country = usersProfile[index]["country"].string
                let phone = usersProfile[index]["phone_number"].string
                let email = usersProfile[index]["email"].string
                let area = usersProfile[index]["area"].string
                let street = usersProfile[index]["street_address"].string
//                let rating = usersProfile[index]["rating"].string
                //TODO: use due date
                let id = usersProfile[index]["pk"].int
                //TODO: apply type safety
                let user = Profile(username: username!, about: about, rating: 0, country: country, street: street, area: area, category: category, phoneNumber: phone, email: email, id: id!)
                users.append(user)
                
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchedProvider" {
            if let vc = segue.destination as? SearchedProviderVC {
                let index = sender as! Int
                vc.pk = users[index].id
            }
        }
    }
    //BACKEND
    func searchUsers(_ myCategory: String) {
        let URL = "\(AppDelegate.URL)/search/"
        if let myToken = defaults.object(forKey: "userToken") as? String{
            print(myToken)
            let headers = [
                "Authorization": myToken
            ]
            let parameters = [
                "category": myCategory
            ]
            Alamofire.request(URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
                if let mydata = String(data: response.data!, encoding: String.Encoding.utf8) {
                    print("my data is \(mydata)")
                }
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
                            print("my json")
                            print(json)
                            self.profiles = JSON(json)
                            self.jsonIntoArrayOfUsers()
                            self.tableView.reloadData()
                        }
                        //TODO: finish loading animation
                    }else {
                        self.alertWithMessage("Could not load Feed information, please try again")
                    }
                }
            })
//            Alamofire.request(.POST, URL, parameters: parameters, headers: headers, encoding: .json).responseJSON { response in
//                if let mydata = String(data: response.data!, encoding: String.Encoding.utf8) {
//                    print("my data is \(mydata)")
//                }
//                print(response.request)
//                print(response.response)
//                print(response.result)
//                if let myResponse = response.response {
//                    if myResponse.statusCode == 200 {
//                        if let json = response.result.value {
//                            print("my json")
//                            print(json)
//                            self.profiles = JSON(json)
//                            self.jsonIntoArrayOfUsers()
//                            self.tableView.reloadData()
//                        }
//                        //TODO: finish loading animation
//                    }else {
//                        self.alertWithMessage("Could not load Feed information, please try again")
//                    }
//                }
//            }
        }
    }
}
