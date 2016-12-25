//
//  ProviderInfoTVC.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 8/23/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol ProviderInfoTVCDelegate: class {
    func shouldPerformSegueToChooseCategoriesVC()
    func dismiss()
    func showAlertWithMessage(_ message: String)
    func shouldAnimateWithMessage(_ message: String)
    func shouldStopAnimating()
}

class ProviderInfoTVC: UITableViewController, EditProvidersProfileDelegate {

    //MARK: IBOutlets
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var categoriesTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var areaTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var categoriesCell: UITableViewCell!
    @IBOutlet weak var categoryButton: UIButton!
    
    //MARK: Variables
    var delegate: ProviderInfoTVCDelegate?
    let defaults = UserDefaults.standard
    var providersCategories = [String]()
    
    //MARK: ViewController lifecycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.tableView.isScrollEnabled = false
        self.tableView.backgroundColor = UIColor.clear
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        print("tableview did load")
        self.tableView.frame.size.height = CGFloat((44*8) + 75)
        delegate?.shouldAnimateWithMessage("loading information")
        Timer.schedule(delay: 5) { timer in
            self.getProfileInfo()
        }
        //print(tableVewHeight())
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("tableview did appear")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView Delegate Functions
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 25))
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        switch section {
            case 0:
                headerLabel.text = "Basic inforamtion"
            case 1:
                headerLabel.text = "Contact infromation"
            case 2:
                headerLabel.text = "Address"
            default : break
        }
        headerLabel.textColor = UIColor.white
        headerLabel.backgroundColor = UIColor.clear
        headerView.addSubview(headerLabel)
        headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 5).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 0).isActive = true
        headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
        headerView.backgroundColor = UIColor(hex: 0xa85783)
        return headerView
    }
    
    //MARK: IBActions
    @IBAction func categoryButtonPressed(_ sender: AnyObject) {
        print("did press choose category button")
        delegate?.shouldPerformSegueToChooseCategoriesVC()
        //performSegueWithIdentifier("categoriesVC", sender: nil)
    }
    
    //MARK: Functions
    func setup() {
        categoryButton.setTitleColor(UIColor(hex: 0xC7C7CD), for: UIControlState())
        categoryButton.setTitle("Choose caegory", for: UIControlState())
        
        if let vc = self.parent as? editProvidersProfile {
            vc.delegate = self
        }
        countryTextField.isEnabled = false
        countryTextField.text = ""
        usernameTextField.isEnabled = false
        usernameTextField.text = ""
        areaTextField.text = ""
        countryTextField.text = ""
        streetAddressTextField.text = ""
        usernameTextField.text = ""
        phoneNumberTextField.text = ""
        emailTextField.text = ""
    }
    func shouldSaveCategories(_ categories: [String]) {
        print("in providers profile information")
        providersCategories = categories
        //TODO: Do validation from parent view controller
        if !categories.isEmpty {
            categoryButton.setTitleColor(UIColor.darkGray, for: UIControlState())
            var myCatgories = ""
            for category in categories {
                myCatgories += "\(category)"
            }
            categoryButton.setTitle(myCatgories, for: UIControlState())
        }
        
    }
    func editProfileRequest(_ profileImage: UIImage?) {
        delegate?.shouldAnimateWithMessage("Updating profile information")
        Timer.schedule(delay: 5) { timer in
            var validInput = true
            if let email = self.emailTextField.text {
                if !email.isValidEmail() && !email.isEmpty{
                    validInput = validInput && false
                    self.delegate?.showAlertWithMessage("Please use a valid email address")
                    self.delegate?.shouldStopAnimating()
                }
            }
            if validInput {
                self.editProfile()
            }
            
        }
    }
    //MARK: BACKEND
    func editProfile() {
        let URL = "\(AppDelegate.URL)/profile/"
        
        if let myToken = defaults.object(forKey: "userToken") as? String{
            print(myToken)
            let headers = [
                "Authorization": myToken
            ]
            //TODO: DO INPUT VALIDATION
            let parameters = [
                "about": bioTextField.text!,
                "phone_number": phoneNumberTextField.text!,
                "email": emailTextField.text!,
                "area": areaTextField.text!,
                "street_address": streetAddressTextField.text!,
                "category": providersCategories[0]
            ]
            Alamofire.request(URL, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
                print(response.request!)  // original URL request
                print(response.response!) // URL response
                print(response.data!)     // server data
                print(response.result)   // result of response serialization
                
                if let requestData = response.data {
                    if let dataString = String(data: requestData, encoding: String.Encoding.utf8) {
                        print("data String : \(dataString)")
                    }
                }
                if let myResponse = response.response {
                    if (myResponse.statusCode) == 200 {
                        //delegate to dimiss EditProfileVC
                        self.delegate?.shouldStopAnimating()
                        self.delegate?.dismiss()
                    }else {
                        //TODO: delegate function to show alert on editProfileVC
                        print("did not set profile")
                        self.delegate?.showAlertWithMessage("could not update profile")
                        self.delegate?.shouldStopAnimating()
                    }
                }else {
                    print("did not set profile")
                    self.delegate?.showAlertWithMessage("could not update profile")
                    self.delegate?.shouldStopAnimating()
                }
            
            })

        }
        self.delegate?.shouldStopAnimating()
    }
    
    func getProfileInfo() {
        let URL = "\(AppDelegate.URL)/profile/"
        if let myToken = defaults.object(forKey: "userToken") as? String{
            print(myToken)
            let headers = [
                "Authorization": myToken
            ]
            Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
                if let myResponse = response.response {
                    if myResponse.statusCode == 200 {
                        if let json = response.result.value {
                            print("my json")
                            print(json)
                            let myJson = JSON(json)
                            if let myUsername = myJson["username"].string {
                                self.usernameTextField.text = myUsername
                            }
                            if let myAbout = myJson["about"].string {
                                self.bioTextField.text = myAbout
                            }
                            if let phoneNo = myJson["phone_number"].string {
                                self.phoneNumberTextField.text = phoneNo
                            }
                            if let email = myJson["email"].string {
                                self.emailTextField.text = email
                            }
                            if let area = myJson["area"].string {
                                self.areaTextField.text = "\(area)"
                            }
                            if  let street = myJson["street_address"].string {
                                self.streetAddressTextField.text = "\(street)"
                            }
                            if let country = myJson["country"].string {
                                self.countryTextField.text = "\(country)"
                            }
                            if let category = myJson["category"].string {
                                self.categoryButton.setTitle(category, for: UIControlState())
                            }
                        
                            
                        }
                        //TODO: finish loading anumation
                        if let mydata = String(data: response.data!, encoding: String.Encoding.utf8) {
                            print("my data from getting profile request is \(mydata)")
                        }
                    }else {
                        self.delegate?.showAlertWithMessage("Could not load profile information, please try again")
                    }
                    self.delegate?.shouldStopAnimating()
                }
            })

        }
    }
    
}
