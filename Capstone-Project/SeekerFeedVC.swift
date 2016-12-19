//
//  SeekerFeedVC.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/22/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class SeekerFeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomSearchControllerDelegate {
    //MARK: Variables
    var dataArray = [String]() //TODO: change to type predefined service
    var filteredArray = [String]()
    let cellID = "ServiceCell"
    var shouldShowSearchResult = false
    var customSearchController: CustomSearchController!
    var serviceID = -1
    var offeredServices: JSON?
    lazy var refreshControl = UIRefreshControl()
    var choosenService: JSON?
    let defaults = UserDefaults.standard
    var servicesObject = [OfferedServiceModel]()
    var filteredServicesObjects = [OfferedServiceModel]()
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()


        setupTablevVieW()
        configureNavigationBar()
        //TODO: delete this line of code - for testing only
        loadCountries()
        ///////////////////////////////////////////////////
        configureSearchController()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gettingOfferedService()
        //TODO: load countries into array of objects after the request finishes
    }
    //MARK: tableview delegate functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResult {
            return filteredServicesObjects.count
        }else {
            return servicesObject.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PredefinedServicesCell
        var service: OfferedServiceModel!
        if shouldShowSearchResult {
            service = filteredServicesObjects[indexPath.row]
        }else {
            service = servicesObject[indexPath.row]
        }
        
        //Cell configuration.
        myCell.serviceTitle.text = service.title
        myCell.servicePrice.text = "\(service.price) KWD"
        myCell.categoryImageView.image = self.imageForCategory(category: service.category)
        myCell.serviceDescription.text = service.description
        print(service.description)
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenService = offeredServices![indexPath.row]
        performSegue(withIdentifier: "OfferedServicesDetails", sender: nil)
        
    }
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        var rotation = CATransform3DMakeRotation(CGFloat(90.0*M_PI)/180, 0.0, 0.7, 0.4)
//        rotation.m34 = 1.0 / -600
//        cell.layer.shadowColor = UIColor.blackColor().CGColor
//        cell.layer.shadowOffset = CGSizeMake(10, 10)
//        cell.alpha = 0
//        
//        cell.layer.transform = rotation
//        cell.layer.anchorPoint = CGPointMake(0, 0.5)
//        
//        UIView.beginAnimations("rotation", context: nil)
//        UIView.setAnimationDuration(0.8)
//        cell.layer.transform = CATransform3DIdentity
//        cell.alpha = 1
//        cell.layer.shadowOffset = CGSizeMake(0, 0)
//        UIView.commitAnimations()
//    }
    //MARK: Functions
    func setupTablevVieW() {
        automaticallyAdjustsScrollViewInsets = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "predefinedServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        tableView.rowHeight = 129
        tableView.separatorStyle = .none
        
        //add refresh controller programmativcally.
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(SeekerFeedVC.refreshTableView), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    func configureNavigationBar() {
        navigationItem.title = "Feed"
    }
    func configureSearchController() {
        //creating and configurating custom search bar
        let searchBarFrame = CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 50.0)
        let searchBarTextColor = UIColor(hex: 0x404040)
        let searchBarTintColor = UIColor.white
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: searchBarFrame,  searchBarTextColor: searchBarTextColor, searchBarTintColor: searchBarTintColor)
        customSearchController.customSearchBar.placeholder = "Search here....."
        customSearchController.customDelegate = self
        tableView.tableHeaderView = customSearchController.customSearchBar
    }
    func refreshTableView() {
        print("refreshing tableview")
        gettingOfferedService()
        //do whatever needed to update tableview
        //then use
        //tableView.reloadData()
        //refreshControl.endRefreshing()
    }
    //MARK: CustomSearchControllerDelegate functions
    func didStartSearching(){
        navigationController?.setNavigationBarHidden(true, animated: true)
        customSearchController.customSearchBar.showsCancelButton = true
        shouldShowSearchResult = true
        tableView.reloadData()
    }
    func didTapOnSearchButton(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        customSearchController.customSearchBar.showsCancelButton = false
        //if let searchText =
        if !shouldShowSearchResult {
            shouldShowSearchResult = true
            tableView.reloadData()
        }
    }
    func didTapOnCancelButton(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        customSearchController.customSearchBar.showsCancelButton = false
        shouldShowSearchResult = false
        tableView.reloadData()
    }
    /*
     {
     "category" : "test category",
     "id" : 35,
     "service" : {
     "status" : "pending",
     "providerpk" : null,
     "id" : 44,
     "price" : 500,
     "title" : "Title",
     "due_date" : null,
     "created" : "2016-09-23T08:40:27Z",
     "seekerpk" : null,
     "description" : "Shared self feel headless wehef",
     "is_special" : false
     },
     "serviceimage_set" : [
     
     ]
     }
     */
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

    func didChangeSearchText(_ searchText: String){
        filteredServicesObjects = [OfferedServiceModel]()
        var servicesTitles = [String]()
        var filteredTitles = [String]()
        for service in servicesObject {
            servicesTitles.append(service.title)
        }
        filteredTitles = servicesTitles.filter({ (title) -> Bool in
            let titleText: NSString = title as NSString
            return titleText.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location != NSNotFound
        })
        for service in servicesObject {
            for title in filteredTitles {
                if service.title == title {
                    filteredServicesObjects.append(service)
                    break
                }
            }
        }
        print(filteredServicesObjects.count)
        tableView.reloadData()
        print(filteredTitles)
    }
    func alertWithMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    //TODO: delete this function - for testing only
    //MARK: loading countries list for testing purposes
    func loadCountries() {
        let countryPath = Bundle.main.path(forResource: "countries", ofType: "txt")
        if let path = countryPath {
            do {
                let countryString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                dataArray = countryString.components(separatedBy: "\n")
            }catch _{
                print("error converting file content into a string")
            }
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OfferedServicesDetails" {
            if let vc = segue.destination as? OfferedServiceDetails {
                vc.myService = choosenService
            }
        }
    }
    func imageForCategory(category: String) -> UIImage{
        
        var image:UIImage!
        switch(category) {
        case "cleaning":
            image = UIImage(named: "cleaning.png")
        case "food":
            image = UIImage(named: "food.png")
        case "errands":
            image = UIImage(named: "errands.png")
        case "pet":
            image = UIImage(named: "pet.png")
        case "real estate":
            image = UIImage(named: "real_estate.png")
        case "beauty":
            image = UIImage(named: "beauty.png")
        case "Others":
            image = UIImage(named: "Others.png")
        default :
            image = UIImage(named: "other.png")
        }
        return image;
        
    }
    //BACKEND
    func gettingOfferedService() {
        //TODO: add loading animation only for the first time.
        let URL = "\(AppDelegate.URL)/offeredservice/"
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
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
                        self.offeredServices = JSON(json)
                        self.jsonIntoArrayOfObjects()
                        self.refreshControl.endRefreshing()
                        self.tableView.reloadData()
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
//        Alamofire.request(.GET, URL, parameters: nil, encoding: .json).responseJSON { response in
//            if let myResponse = response.response {
//                if myResponse.statusCode == 200 {
//                    if let json = response.result.value {
//                        self.offeredServices = JSON(json)
//                        self.jsonIntoArrayOfObjects()
//                        self.refreshControl.endRefreshing()
//                        self.tableView.reloadData()
//                    }
//                }else {
//                    self.alertWithMessage("There was a problem getting offered services\n please try again")
//                    self.refreshControl.endRefreshing()
//                }
//            }else {
//                self.alertWithMessage("There was a problem getting offered services\n please try again")
//                self.refreshControl.endRefreshing()
//            }
//        }
        
    }

}
