//
//  OfferedServiceDetailsP.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 9/20/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class OfferedServiceDetailsP: UIViewController, UITableViewDelegate, UITableViewDataSource, iCarouselDelegate, iCarouselDataSource {

    //MARK: IBOutlets
    @IBOutlet weak var picturesView: iCarousel!
    @IBOutlet weak var request: UIButton!
    @IBOutlet weak var tableView: UITableView! //cell height = 45
    @IBOutlet weak var availableServiceDaysLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    //MARK: Vaiables
    let defaults = UserDefaults.standard
    var CellID = "timeCell"
    var timeData = ["service is avaialble at any time"]
    var serviceImages = [UIImage]()
    var serviceID: Int?
    var isSeeker = false
    var myService: OfferedServiceModel!
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        if !isSeeker {
            request.heightAnchor.constraint(equalToConstant: 0)
            request.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adjustContentViewHeight()
        if let id = serviceID {
            offeredServiceDetails(id)
        }
        if isSeeker {
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        setupTableViewHeight()
    }
    
    @IBAction func requestAction(_ sender: Any) {
        requestOfferedServiceWithPK(serviceID!)
    }
    //MARK: Functions
    func setup() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        setupNavigationBar()
        setupTableView()
        priceLabel.text = "Price: "
        descriptionTextView.text = "Service description will be here"
        picturesView.delegate = self
        picturesView.dataSource = self
        picturesView.type = .rotary
        picturesView .reloadData()
        picturesView.clipsToBounds = true
        
        //TODO: DELETE THIS
        serviceImages.append(UIImage(named: "profileImagePlaceholder")!)
        serviceImages.append(UIImage(named: "profileImagePlaceholder")!)
        serviceImages.append(UIImage(named: "profileImagePlaceholder")!)
        serviceImages.append(UIImage(named: "profileImagePlaceholder")!)
        serviceImages.append(UIImage(named: "profileImagePlaceholder")!)
        serviceImages.append(UIImage(named: "profileImagePlaceholder")!)
        picturesView.reloadData()
    }
    func setupTableViewHeight() {
        tableViewHeight.constant = 45 * CGFloat(timeData.count)
    }
    func setupNavigationBar() {
        navigationItem.title = "Service Title"
        if !isSeeker {
                let editBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editService))
            navigationItem.rightBarButtonItem = editBarButtonItem

        }
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = 45
    }
    func editService() {
        print("will edit this offered service")
        performSegue(withIdentifier: "EditService", sender: nil)
    }
    func adjustContentViewHeight() {
        var contentRect = CGRect.zero
        for view in containerView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        containerViewHeight.constant = contentRect.size.height+20
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: CellID)
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath)
        cell.textLabel?.text = "\(timeData[indexPath.row])"
        cell.selectionStyle  = .none
        return cell
    }
    
    //MARK: iCarousel Delegate Function (for services images)
    func numberOfItems(in carousel: iCarousel) -> Int {
        return serviceImages.count
    }
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let tempView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        tempView.contentMode = .scaleAspectFill
        tempView.clipsToBounds = true
        tempView.image = serviceImages[index]
        return tempView
    }
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            return value*2.1
        }
        return value
    }
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        performSegue(withIdentifier: "ImagePreviewVC", sender: index)
    }
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let myIndex = sender as? Int
        if segue.identifier == "ImagePreviewVC" {
            if let vc = segue.destination as? ImagePreview {
                if let index = myIndex {
                    vc.imageIndex = index
                    vc.image = serviceImages[index]
                }
                
            }
        }else if segue.identifier == "EditService" {
            if let myID = serviceID {
                if let vc = segue.destination as? addService {
                    vc.willEdit = true
                    vc.serviceID = myID
                }
            }
            
        }
    }
    func alertWithMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    //MARK: BACKEND
    func offeredServiceDetails(_ id: Int?) {
        //TODO: add loading animation only for the first time.
        let URL = "\(AppDelegate.URL)/offeredservice/"
        
        let parameter:[String:Int]
        if let myId = id {
            parameter = [
                "servicepk": myId
            ]
        }else {
            parameter = [
                "servicepk": 0
            ]
        }
        Alamofire.request(URL, method: .get, parameters: parameter).responseJSON { (response) in
            if let myResponse = response.response {
                if myResponse.statusCode == 200 {
                    if let json = response.result.value {
                        print(json)
                        let myJson = JSON(json)
                        if let myTitle = myJson["service"]["title"].string {
                            print(myTitle)
                            self.navigationItem.title = myTitle
                        }else {
                            self.navigationItem.title = "Untitled"
                        }
                        if let myDescription = myJson["service"]["description"].string {
                            self.descriptionTextView.text = myDescription
                        }else {
                            self.descriptionTextView.text = "no description"
                        }
                        if let myPrice = myJson["service"]["price"].float {
                            self.priceLabel.text = "Price: \(myPrice) KWD"
                        }else {
                            self.descriptionTextView.text = "no price"
                        }
                        if let days = myJson["days"].string {
                            self.availableServiceDaysLabel.text = "Service is available every: "+days
                        }else {
                            self.availableServiceDaysLabel.text = "Service is available all week"
                        }
                        if let from = myJson["from_datetime"].string {
                            self.timeData+=["Available From:"]
                            self.timeData+=[from]
                            if let to = myJson["to_datetime"].string{
                                self.timeData+=["to:"]
                                self.timeData+=[to]
                            }
                            self.tableView.reloadData()
                        }else {
                            self.timeData.append("Service is available at all times")
                            self.tableView.reloadData()
                        }
                    }
                }else {
                    self.alertWithMessage("There was a problem getting offered services\n please try again")
                }
            }else {
                self.alertWithMessage("There was a problem getting offered services\n please try again")
            }
        }
        self.tableView.reloadData()
    }
    func requestOfferedServiceWithPK(_ pk: Int) {
        let URL = "\(AppDelegate.URL)/request/"
        if let myToken = defaults.object(forKey: "userToken") as? String{
            print(myToken)
            let headers = [
                "Authorization": myToken
            ]
            let parameters = [
                "servicepk": pk
            ]
            Alamofire.request(URL, method: .post, parameters: parameters, headers: headers).responseJSON(completionHandler: { (response) in
                print("request")
                print(response.request!)  // original URL request
                print("response")
                print(response.response!) // URL response
                print("data")
                print(response.data!)     // server data
                print("result")
                print(response.result)   // result of response serialization
                
                if response.response?.statusCode == 201 {
                    if let json = response.result.value {
                        print("my json")
                        print(json)
                        let myJson = JSON(json)
                        print(myJson)
                        let alertController = UIAlertController(title: "Thank You", message: "Thank you for requesting this service", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                    if let mydata = String(data: response.data!, encoding: String.Encoding.utf8) {
                        print("my data from getting profile request is \(mydata)")
                    }
                }else {
                    self.alertWithMessage("Could not request this service")
                    if let mydata = String(data: response.data!, encoding: String.Encoding.utf8) {
                        print("my data from getting profile request is \(mydata)")
                    }
                }
            })
            
        }
    }
}
