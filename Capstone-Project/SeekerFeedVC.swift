//
//  SeekerFeedVC.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/22/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class SeekerFeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomSearchControllerDelegate {
    //MARK: Variables
    var dataArray = [String]() //TODO: change to type predefined service
    var filteredArray = [String]()
    let cellID = "ServiceCell"
    var shouldShowSearchResult = false
    var customSearchController: CustomSearchController!
    var serviceID = -1
    lazy var refreshControl = UIRefreshControl()
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
    
    //MARK: tableview delegate functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResult {
            return filteredArray.count
        }else {
            return dataArray.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! PredefinedServicesCell
        
        //Cell configuration.
        if shouldShowSearchResult {
            myCell.serviceTitle.text = "\(filteredArray[indexPath.row])"
        }else {
            myCell.serviceTitle.text = "\(dataArray[indexPath.row])"
        }
        myCell.servicePrice.text = "10"
        myCell.serviceCurrency.text = "KWD"
        myCell.serviceDescription.text = "This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description This is a service description"
        return myCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FeedDetailedPredefinedServiceSegue" {
            if let destination = segue.destinationViewController as? SeekerDetailedPredefinedServiceVC {
                destination.ServiceID = serviceID
                destination.UserType = 1
                
            }
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        serviceID = indexPath.row
        performSegueWithIdentifier("FeedDetailedPredefinedServiceSegue", sender: nil)
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
        tableView.registerNib(UINib(nibName: "predefinedServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        tableView.rowHeight = 129
        tableView.separatorStyle = .None
        
        //add refresh controller programmativcally.
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(SeekerFeedVC.refreshTableView), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    func configureNavigationBar() {
        navigationItem.title = "Feed"
    }
    func configureSearchController() {
        //creating and configurating custom search bar
        let searchBarFrame = CGRectMake(0.0, 0.0, tableView.frame.size.width, 50.0)
        let searchBarTextColor = UIColor(hex: 0x3399CC)
        let searchBarTintColor = UIColor.whiteColor()
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: searchBarFrame,  searchBarTextColor: searchBarTextColor, searchBarTintColor: searchBarTintColor)
        customSearchController.customSearchBar.placeholder = "Search here....."
        customSearchController.customDelegate = self
        tableView.tableHeaderView = customSearchController.customSearchBar
    }
    func refreshTableView() {
        print("refreshing tableview")
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
    func didChangeSearchText(searchText: String){
        filteredArray = dataArray.filter({ (country) -> Bool in
            let countryText: NSString = country
            return countryText.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location != NSNotFound
        })
        tableView.reloadData()
    }
    
    //TODO: delete this function - for testing only
    //MARK: loading countries list for testing purposes
    func loadCountries() {
        let countryPath = NSBundle.mainBundle().pathForResource("countries", ofType: "txt")
        if let path = countryPath {
            do {
                let countryString = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                dataArray = countryString.componentsSeparatedByString("\n")
            }catch _{
                print("error converting file content into a string")
            }
            
        }
    }

}
