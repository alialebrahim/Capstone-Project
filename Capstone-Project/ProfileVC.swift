//
//  providerInfoVC.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 6/20/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import SwiftyJSON

protocol ProfileDelegate: class{
    func didSwipeLeft()
}

//provider tabs (profile, feed, services, chat?)
class ProfileVC: UIViewController, UIScrollViewDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImage: CircularImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var ratingStarsView: CosmosView!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var workingFields: UILabel!
    @IBOutlet weak var providersMobileNumber: UIButton!
    @IBOutlet weak var providersEmailAddress: UIButton!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var remainingTasksView: UIView!
    @IBOutlet weak var completedTasksView: UIView!
    @IBOutlet weak var categories: UILabel!
    //MARK: Variables
    weak var delegate: ProfileDelegate?
    let defaults = UserDefaults.standard
    var providersPK: Int?
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.view.backgroundColor = UIColor.white
        configureNavigationBar()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createRatingView()
        //TODO: start loading anumation
        //TODO: web request to get profile information.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adjustContentViewHeight()
        LoadingView.addLoadingViewTo(self.view)
        navigationController?.setNavigationBarHidden(true, animated: false)
        LoadingView.startAnimatingWithMessage("Getting profile information")
        Timer.schedule(delay: 5) { timer in
            self.getProfileInfo()
        }

    }
    
    //MARK: IBActions
    @IBAction func callProviderButtonPressed() {
        if let phoneNumberString = providersMobileNumber.currentTitle {
            if phoneNumberString != "no phone number" {
                print("there is a phone number")
                if let phoneNumberURL = URL(string: "telprompt://\(phoneNumberString)") {
                    if UIApplication.shared.canOpenURL(phoneNumberURL) {
                        UIApplication.shared.openURL(phoneNumberURL)
                    }
                }
            }else {
                print("no phone number")
            }
            
        }
    }
    @IBAction func emailProviderButtonPressed(_ sender: AnyObject) {
        if let emailString = providersEmailAddress.currentTitle {
            if emailString != "no email" {
                if let emailURL = URL(string: "mailto://\(emailString)"){
                    if UIApplication.shared.canOpenURL(emailURL) {
                        UIApplication.shared.openURL(emailURL)
                    }
                }
            }else {
                print("no email added")
            }
        }
    }
    //MARK: Functions
    func setup() {
        automaticallyAdjustsScrollViewInsets = false
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.isUserInteractionEnabled = true
        //TODO: obtain these information from the backend
        bioTextView.textAlignment = .justified
        bioTextView.isEditable = false
        bioTextView.isSelectable = false
        bioTextView.dataDetectorTypes = .link
        bioTextView.contentInset = UIEdgeInsetsMake(0,-5,0,0)
        address.numberOfLines = 5
//        let colors = [UIColor(hex: 0xB39DDB), UIColor(hex: 0x7E57C2)]
//        self.view.setGradientBackground(colors)
        self.view.backgroundColor = UIColor.white
        profileImage.addBorderWith(color: UIColor(hex: 0x404040), borderWidth: 2)
        workingFields.textColor = UIColor(hex: 0xa85783)
//        workingFields.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
//        workingFields.layer.shadowOffset = CGSize(width: 0, height: 0)
//        workingFields.layer.shadowOpacity = 1
//        workingFields.layer.shadowRadius = 6
        providersMobileNumber.setTitleColor(UIColor(hex: 0xa85783), for: UIControlState())
        providersEmailAddress.setTitleColor(UIColor(hex: 0xa85783), for: UIControlState())
        contentView.backgroundColor = UIColor.clear
        bioTextView.backgroundColor = UIColor.clear
        workingFields.text = "Development Services, Design Services, Teaching Services"
        workingFields.numberOfLines = 4
        //topContainerView.backgroundColor = UIColor(hex: 0xB39DDB)
        topContainerView.backgroundColor = UIColor.clear
        //remainingTasksView.backgroundColor = UIColor(hex: 0xB39DDB)
        remainingTasksView.backgroundColor = UIColor.clear
        completedTasksView.addLeadingBorderWithColor(UIColor(hex: 0xa85783), width: 1)
        completedTasksView.addBottomBorderWithColor(UIColor(hex: 0xa85783), width: 1)
        remainingTasksView.addBottomBorderWithColor(UIColor(hex: 0xa85783), width: 1)
        remainingTasksView.addTopBorderWithColor(UIColor(hex: 0xa85783), width: 1)
        //completedTasksView.backgroundColor = UIColor(hex: 0xB39DDB)
        completedTasksView.backgroundColor = UIColor.clear
        completedTasksView.addTopBorderWithColor(UIColor(hex: 0xa85783), width: 1)
        //swipe gesture needed to navigate between tabs for the seeker
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeAction))
        swipeGesture.direction = .left
        view.addGestureRecognizer(swipeGesture)
        
        
        /**/
        username.text = ""
        bioTextView.text = ""
        workingFields.text = ""
        providersMobileNumber.setTitle("", for: UIControlState())
        providersEmailAddress.setTitle("", for: UIControlState())
        address.text = ""

        /**/
    }
    func configureNavigationBar() {
        let editProfileItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editProfile))
        editProfileItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = editProfileItem

        let img = UIImage(named: "folder")!
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button.setBackgroundImage(img, for: UIControlState())
        button.addTarget(self, action: #selector(OfferedServices), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)

        
        //title color
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
  
    }
    func OfferedServices() {
        if let pk = providersPK {
            performSegue(withIdentifier: "OfferedServicesVC", sender: pk);
        }else {
            performSegue(withIdentifier: "OfferedServicesVC", sender: nil);
        }
    }
    func editProfile() {
        performSegue(withIdentifier: "EditProfileVC", sender: nil)
    }
    func createRatingView() {
        let color = UIColor(hex: 0x404040)
        let ratingView = CosmosView()
        ratingView.settings.updateOnTouch = false
        ratingView.settings.fillMode = .half
        ratingView.settings.emptyBorderColor = color
        ratingView.settings.filledBorderColor = color
        ratingView.settings.filledColor = color
        ratingView.settings.textColor = color
        ratingView.text = "(0)" //TODO: obtain from the backend
        ratingView.rating = 0 //TODO: obtain this from the backend
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ratingView)
        ratingView.topAnchor.constraint(equalTo: workingFields.bottomAnchor, constant: 8).isActive = true
        ratingView.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8).isActive = true
    }
    func leftSwipeAction() {
        print("im here")
        delegate?.didSwipeLeft()
    }
    func adjustContentViewHeight() {
        var contentRect = CGRect.zero;
        for view in self.contentView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        if contentRect.size.height > contentViewHeight.constant {
            contentViewHeight.constant = contentRect.size.height + 20
        }
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    func alertWithMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pk = sender as? Int {
            if segue.identifier == "OfferedServicesVC" {
                if let vc = segue.destination as? OfferedServicesVC {
                    vc.providersPK = pk
                }
            }
        }
    }
    //MARK: BACKEND 
    func getProfileInfo() {
        let URL = "\(AppDelegate.URL)/profile/"
        if let myToken = defaults.object(forKey: "userToken") as? String{
            print(myToken)
            let headers = [
                "Authorization": myToken
            ]
            
            Alamofire.request(.GET, URL, parameters: nil, headers: headers, encoding: .json).responseJSON { response in
                if let myResponse = response.response {
                    if myResponse.statusCode == 200 {
                        if let json = response.result.value {
                            print("my json")
                            print(json)
                            let myJson = JSON(json)
                            if let myUsername = myJson["username"].string {
                                self.username.text = myUsername
                            }
                            if let myAbout = myJson["about"].string {
                                self.bioTextView.text = myAbout
                            }else{
                                self.bioTextView.text = "no description"
                            }
                            if let phoneNo = myJson["phone_number"].string {
                                self.providersMobileNumber.setTitle(phoneNo, for: UIControlState())
                            }else {
                                self.providersMobileNumber.setTitle("no phone number", for: UIControlState())
                            }
                            if let email = myJson["email"].string {
                                self.providersEmailAddress.setTitle(email, for: UIControlState())
                            }else {
                                self.providersEmailAddress.setTitle("no email", for: UIControlState())
                            }
                            if let area = myJson["area"].string {
                                self.address.text = "\(area)"
                            }
                            if  let street = myJson["street_address"].string {
                                self.address.text = "\(self.address.text!) \(street)"
                            }
                            if let country = myJson["country"].string {
                                self.address.text = "\(self.address.text!) \(country)"
                            }
                            if let category = myJson["category"].string {
                                self.categories.text = "\(category)"
                            }
                            if let pk = myJson["pk"].int {
                                print("providers pk is \(pk)")
                                self.providersPK = pk
                            }
                        }
                        //TODO: finish loading anumation
                        if let mydata = String(data: response.data!, encoding: String.Encoding.utf8) {
                            print("my data from getting profile request is \(mydata)")
                        }
                    }else {
                        self.alertWithMessage("Could not load profile information, please try again")
                    }
                }
            }
        }
        navigationController?.setNavigationBarHidden(false, animated: false)
        LoadingView.stopAnimating()
    }
}

