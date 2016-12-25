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
    var withBid = false
    var isSpecial = false
    var fromWorkingon = false
    var userType = "provider"
    var providerBid: Int?
    var myTextField: UITextField!
    let defaults = UserDefaults.standard
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dueLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
//    let defaults = UserDefaults.standard
    var serviceID: Int!
    var myService: PublicServiceModel!
    var mySpecialService: specialServiceModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupMyService()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //TODO: adjust content height inside getpublicservice
        //getPublicService()
        print("IM HERE :P:P")
        adjustContentViewHeight()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustContentViewHeight()
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
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
            button.translatesAutoresizingMaskIntoConstraints = false
            if isSpecial {
                button.isHidden = true
                print("special service all the way")
            }else if fromWorkingon {
                print("from working on")
                for bid in myService.bids! {
                    print(bid.status)
                    if bid.status == "accepted" {
                        button.setTitle("Your bid is: \(bid.bid!)", for: UIControlState())
                    }
                }
            }else if withBid == false {
                button.addTarget(self, action: #selector(bidOnService), for: .touchUpInside)
                button.setTitle("bid on this service", for: UIControlState())
                
            }else {
                button.addTarget(self, action: #selector(editBidOnService), for: .touchUpInside)
                button.setTitle("Edit your bid", for: UIControlState())
            }
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = UIColor(hex: 0xa85783)
            //button.layer.cornerRadius = 20
            containerView.addSubview(button)
            button.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 8).isActive = true
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: view.frame.size.width/2).isActive = true
            
        }else if userType == "seeker" {
            if !isSpecial {
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.addTarget(self, action: #selector(showBids), for: .touchUpInside)
                button.setTitle("Show bids", for: UIControlState())
                button.setTitleColor(UIColor.black, for: UIControlState())
                button.layer.borderColor = UIColor.black.cgColor
                button.layer.borderWidth = 1
                containerView.addSubview(button)
                button.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 8).isActive = true
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                button.widthAnchor.constraint(equalToConstant: view.frame.size.width/2).isActive = true
            }
        }
    }
    func setupMyService() {
        if isSpecial {
            serviceID = mySpecialService.id!
            self.descriptionTextView.text = mySpecialService.description
            self.priceLabel.text = "\(mySpecialService.price) KWD"
            self.statusLabel.text = "Status: "+mySpecialService.status!
            self.categoryLabel.text = "Category: other"
            navigationItem.title = mySpecialService.title
            createdLabel.text = "Created on: "+mySpecialService.created!
            if let due = mySpecialService.dueDate {
                print(due)
                dueLabel.text = "Due to: "+due
            }else {
                dueLabel.text = "Due to: -"
            }
        }else {
            serviceID = myService.id!
            self.descriptionTextView.text = myService.description
            self.priceLabel.text = "\(myService.price) KWD"
            self.statusLabel.text = "Status: "+myService.status!
            self.categoryLabel.text = "Category: "+myService.category
            navigationItem.title = myService.title
            createdLabel.text = "Created on: "+myService.created!
            if let due = myService.dueDate {
                dueLabel.text = "Due to: "+due
            }else {
                dueLabel.text = "Due to: -"
            }
        }
    }
    func showBids(){
        performSegue(withIdentifier: "showBids", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBids" {
            if let vc = segue.destination as? ShowBids {
                vc.myService = self.myService
            }
        }
    }
    func editBidOnService() {
        print("im here")
        let alertController = UIAlertController(title: "Bid", message: "You are bidding on - Service title", preferredStyle: .alert)
        let bidAction = UIAlertAction(title: "Bid", style: .destructive) { (UIAlertAction) in
            print("bidding on service")
            if let bidAmount = self.myTextField.text {
                let providerPK = self.defaults.object(forKey: "userPK") as! Int
                if let bids = self.myService.bids {
                    for bid in bids {
                        if bid.bidder! == providerPK {
                            let myBid = Int(bidAmount)
                            self.updateBid(pk: bid.id!, bid: myBid!)
                        }
                    }
                }
                print(bidAmount)
            }
            print(self.myTextField.text)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(bidAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textField) in
            textField.text = "\(self.myService.providerBid!)"
            textField.keyboardType = .numbersAndPunctuation
            self.myTextField = textField
        }
        present(alertController, animated: true, completion: nil)
    }
    func bidOnService() {
        print("im here")
        //TODO: change it to real service title
        let alertController = UIAlertController(title: "Bid", message: "You are bidding on - Service title", preferredStyle: .alert)
        let bidAction = UIAlertAction(title: "Bid", style: .destructive) { (UIAlertAction) in
            print("bidding on service")
            if let bidAmount = self.myTextField.text {
                let bid = Int(bidAmount)
                self.bid(myBid: bid!)
                print(bidAmount)
            }
            print(self.myTextField.text)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(bidAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textField) in
            textField.placeholder = "Your bid"
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
        if contentRect.height > self.view.frame.height+200 {
            containerViewHeightConstraint.constant = contentRect.size.height+20
        }
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
    func updateBid(pk: Int, bid: Int) {
        let URL = "\(AppDelegate.URL)/bid/"
        if let myToken = defaults.object(forKey: "userToken") as? String{
            
            let headers = [
                "Authorization": myToken
            ]
            let parameters = [
                "pk": pk,
                "bid": bid
            ]
            Alamofire.request(URL, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
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
                        let alertController = UIAlertController(title: "Thank You", message: "Thank you for updating your bid on this service", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }else {
                        self.alertWithMessage("Could not update bid")
                    }
                }
            })
        }
    }
    func bid(myBid: Int) {
        print(":P:P")
        let URL = "\(AppDelegate.URL)/bid/"
        if let myToken = defaults.object(forKey: "userToken") as? String{
            
            let headers = [
                "Authorization": myToken
            ]
            let parameters = [
                "service": serviceID,
                "bid":  myBid,
                "bidder": defaults.object(forKey: "userPK") as! Int
            ] as [String : Any]
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
                    if myResponse.statusCode == 201 {
                        print("its working!!")
                        let alertController = UIAlertController(title: "Thank You", message: "Thank you for bidding on this service", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertController.addAction(okAction)
                    
                        self.present(alertController, animated: true, completion: nil)
                    }else {
                        self.alertWithMessage("Could not place a bid\n Please try again")
                    }
                    
                }
            })
        }
    }
//    func getPublicService() {
//        print("spongebob")
//        let URL = "\(AppDelegate.URL)/pubs/"
//        if let myToken = defaults.object(forKey: "userToken") as? String{
////            let headers = [
////                "Authorization": myToken
////            ]
//            let parameters = [
//                "servicepk": serviceID
//            ]
//            Alamofire.request(URL, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
//                
//                print("request")
//                print(response.request!)  // original URL request
//                print("response")
//                print(response.response!) // URL response
//                print("data")
//                print(response.data!)     // server data
//                print("result")
//                print(response.result)   // result of response serialization
//                if let myResponse = response.response {
//                    if myResponse.statusCode == 200 {
//                        if let json = response.result.value {
//                            print("my json")
//                            print(json)
//                            let myJson = JSON(json)
//                            if let title = myJson["service"]["title"].string {
//                                self.navigationItem.title = title
//                            }
//                            if let description = myJson["service"]["description"].string {
//                                self.descriptionTextView.text = description
//                            }
//                            if let price = myJson["service"]["price"].float {
//                                self.priceLabel.text = "\(price) kWD"
//                            }
//                            if let created = myJson["service"]["status"].string {
//                                self.createdLabel.text = "Created: "+created
//                            }
//                            if let status = myJson["service"]["status"].string {
//                                self.statusLabel.text = "Status "+status
//                            }
//                            if let category = myJson["category"].string {
//                                self.categoryLabel.text = "Category: \(category) Services"
//                            }
//                            
//                            
//                        }
//                    }else {
//                        self.alertWithMessage("Could not load service information, please try again")
//                    }
//                }
//            })
//        }
//    }

}
