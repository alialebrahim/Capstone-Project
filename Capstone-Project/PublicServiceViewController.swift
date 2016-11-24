//
//  PublicServiceViewController.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 9/20/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class PublicServiceViewController: UIViewController {
    
    var userType = "provider"
    var providerBid: Int?
    var myTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dueLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let defaults = UserDefaults.standard
    var serviceID: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //TODO: adjust content height inside getpublicservice
        getPublicService()
        adjustContentViewHeight()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setup() {
        automaticallyAdjustsScrollViewInsets = false
        descriptionTextView.text = ""
        priceLabel.text = ""
        statusLabel.text = ""
        createdLabel.text = ""
        categoryLabel.text = ""
        setupNavigationBar()
        if userType == "provider" {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(bidOnService), for: .touchUpInside)
            button.setTitle("bid on this service", for: UIControlState())
            button.setTitleColor(UIColor.black, for: UIControlState())
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1
            containerView.addSubview(button)
            button.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8).isActive = true
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: view.frame.size.width/2).isActive = true
        }else if userType == "seeker" {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(showBids), for: .touchUpInside)
            button.setTitle("Show bids", for: UIControlState())
            button.setTitleColor(UIColor.black, for: UIControlState())
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1
            containerView.addSubview(button)
            button.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8).isActive = true
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: view.frame.size.width/2).isActive = true
        }
    }
    func showBids(){
        print("showing bids")
    }
    func bidOnService() {
        //TODO: change it to real service title
        let alertController = UIAlertController(title: "Bid", message: "You are bidding on - Service title", preferredStyle: .alert)
        let bidAction = UIAlertAction(title: "Bid", style: .destructive) { (UIAlertAction) in
            print("bidding on service")
            print(self.myTextField.text)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(bidAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textField) in
            textField.placeholder = "You bid"
            textField.keyboardType = .numbersAndPunctuation
            self.myTextField = textField
        }
        present(alertController, animated: true, completion: nil)
    }
    func setupNavigationBar() {
        navigationItem.title = "Service title"
    }
    func adjustContentViewHeight() {
        var contentRect = CGRect.zero
        for view in containerView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        containerViewHeightConstraint.constant = contentRect.size.height+20
    }
    func alertWithMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: BACKEND
    func getPublicService() {
        print("spongebob")
        let URL = "\(AppDelegate.URL)/pubs/"
        if let myToken = defaults.object(forKey: "userToken") as? String{
            let headers = [
                "Authorization": myToken
            ]
            let parameters = [
                "servicepk": serviceID
            ]
            Alamofire.request(URL, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
                print(response.request!)  // original URL request
                print(response.response!) // URL response
                print(response.data!)     // server data
                print(response.result)   // result of response serialization
                if let myResponse = response.response {
                    if myResponse.statusCode == 200 {
                        if let json = response.result.value {
                            print("my json")
                            print(json)
                            let myJson = JSON(json)
                            if let title = myJson["service"]["title"].string {
                                
                            }
                            if let description = myJson["service"]["description"].string {
                                self.descriptionTextView.text = description
                            }
                            if let price = myJson["service"]["price"].float {
                                self.priceLabel.text = "\(price) kWD"
                            }
                            if let created = myJson["service"]["status"].string {
                                self.createdLabel.text = created
                            }
                            if let status = myJson["service"]["status"].string {
                                self.statusLabel.text = status
                            }
                            if let category = myJson["category"].string {
                                self.categoryLabel.text = "\(category)"
                            }
                            
                            
                        }
                    }else {
                        self.alertWithMessage("Could not load profile information, please try again")
                    }
                }
            })
//            Alamofire.request(.GET, URL, parameters: parameters,headers: headers, encoding: .json).responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
//                if let myResponse = response.response {
//                    if myResponse.statusCode == 200 {
//                        if let json = response.result.value {
//                            print("my json")
//                            print(json)
//                            let myJson = JSON(json)
//                            if let tite = myJson["service"]["title"].string {
//                                
//                            }
//                            if let description = myJson["service"]["description"].string {
//                                self.descriptionTextView.text = description
//                            }
//                            if let price = myJson["service"]["price"].float {
//                                self.priceLabel.text = "\(price) kWD"
//                            }
//                            if let created = myJson["service"]["status"].string {
//                                self.createdLabel.text = created
//                            }
//                            if let status = myJson["service"]["status"].string {
//                                self.statusLabel.text = status
//                            }
//                            if let category = myJson["category"].string {
//                                self.categoryLabel.text = "\(category)"
//                            }
//                            
//                            
//                        }
//                    }else {
//                        self.alertWithMessage("Could not load profile information, please try again")
//                    }
//                }
//            }
        }
//        navigationController?.setNavigationBarHidden(false, animated: false)
//        LoadingView.stopAnimating()
    }

}
