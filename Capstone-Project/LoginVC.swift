//
//  LoginVC.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 5/29/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import SwiftyJSON

//TODO: notificaion if email or password are incorrect!
class LoginVC: UIViewController, SubmitButtonDelegate {
    
    
    // MARK: IBOutlets
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: SubmitButton!
    @IBOutlet weak var forgotYourPasswordButton: UIButton!
    // MARK: Variables
    var loginAttempt = 0
    let defaults = NSUserDefaults.standardUserDefaults()
    var token = ""
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //observer to notify the view when the keyboard appears or disappear.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
 
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        offeredServiceCreation()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //hiding navigation controller when view disappears.
        self.navigationController?.navigationBar.hidden = true
    }
    // MARK: IBActions
    @IBAction func loginButtonPressed(sender: AnyObject) {
        loginButton.startLoadingAnimation()
        NSTimer.schedule(delay: 1) { (timer) in
            self.performSegueWithIdentifier("ProfileVC", sender: nil)
        }
        
    }
    @IBAction func createAcccountButtonPressed(sender: AnyObject) {
        print("create account")
    }
    @IBAction func forgotYourPasswordButtonPressed(sender: AnyObject) {
        print("forgot password")
    }
    // MARK: Functions
    func setup() {
        /*
        *
        *setting up self.view
        */
        //Tap gesture is added to hide the keyboard when the user tap on the screen.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        let colors = [UIColor(hex: 0xB39DDB), UIColor(hex: 0x7E57C2)]
        self.view.setGradientBackground(colors)
        self.view.bringSubviewToFront(passwordTextField)
        self.view.bringSubviewToFront(emailTextField)
        self.view.bringSubviewToFront(logoLabel)
        self.view.bringSubviewToFront(logoImageView)
        self.view.bringSubviewToFront(loginButton)
        self.view.bringSubviewToFront(forgotYourPasswordButton)
        self.view.bringSubviewToFront(createAccountButton)
        /*
         *
         *setting up logo image
         */
        let origImage = logoImageView.image!
        let tintedImage = origImage.imageWithRenderingMode(.AlwaysTemplate)
        logoImageView.image = tintedImage
        logoImageView.tintColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        logoImageView.contentMode = .ScaleAspectFit
        
        /*
         *
         *setting up textFields
         */
        emailTextField.textAlignment = .Left
        emailTextField.keyboardType = .EmailAddress
        passwordTextField.textAlignment = .Left
        passwordTextField.keyboardType = .Default
        passwordTextField.secureTextEntry = true
        
        /*
         *
         *setting up login button
         */
        loginButton.setTitle("Login", forState: .Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        loginButton.delegate = self
        loginButton.layer.cornerRadius = self.loginButton.frame.height / 2
        
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func keyboardWillShow(notification: NSNotification) {
        //getting the keyboard height to move the bottom view above the keyboard by modifying its constraint
//        let userInfo = notification.userInfo!
//        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
//        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
//        bottomViewButtomConstain.constant =  keyboardViewEndFrame.height
//        bottomView.layoutIfNeeded()

    }
    func keyboardWillHide(notification: NSNotification) {
        //returning the bottom view to its original place.
//        bottomViewButtomConstain.constant = 0
//        bottomView.layoutIfNeeded()
    }
    
    func didAnimate(frame: CGRect) {
        let activity = NVActivityIndicatorView(frame: frame, type: .BallClipRotateMultiple, color: UIColor.whiteColor())
        view.addSubview(activity)
        view.bringSubviewToFront(activity)
        activity.startAnimation()
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    func signUpTest() {
        let URL = "http://81.4.110.27/signup/"
        let parameters = [
            "username": "sljfnssdlfjnsldjfn",
            "password": "AliAlebrahim1003"
        ]
        
        Alamofire.request(.POST, URL, parameters: parameters, encoding: .JSON).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            if let requestData = response.data {
                if let dataString = String(data: requestData, encoding: NSUTF8StringEncoding) {
                    self.storeToken(dataString)
                }
            }
            print(response.result)   // result of response serialization
            if response.response?.statusCode == 201 {
                if let json = response.result.value {
                    print("my json")
                    print(json)
                    let myJson = JSON(json)
                    if let userID = myJson["userid"].string {
                        print("user id")
                        print(userID)
                    }
                }
                if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
                    print(mydata)
                }
            }else {
                print("not successful")
            }
            
        }
    }
    func loginTest() {
        let URL = "http://81.4.110.27/login/"
        let parameters = [
            "username": "sljfnssdlfjnsldjfn",
            "password": "AliAlebrahim1003"
        ]
        
        Alamofire.request(.POST, URL, parameters: parameters, encoding: .JSON).validate().response {
            (request, response, data, error) in
            if (response?.statusCode)! == 200 {
                if let requestData = data {
                    if let dataString = String(data: requestData, encoding: NSUTF8StringEncoding) {
                        self.storeToken(dataString)
                    }
                }
            }else {
                //did not login
                print("did not login")
            }
            print("request")
            print(request)
            print("response")
            print(response)
            print("data")
            print(data)
            print("error")
            print(error)
        }
        
    }
    func feedTest() {
    
        let URL = "http://81.4.110.27/predefinedservice/"
        
        Alamofire.request(.GET, URL, parameters: nil).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
                print(mydata)
            }
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }
    
    func storeToken(token: String) {
        print(token)
        defaults.setObject(token, forKey: "userToken")
        
        //this is how to get the token back.
        /*****************************************************
        if let mytoken = defaults.objectForKey("userToken") {
            print("from user defaults token is \(mytoken)")
        }
        *****************************************************/
    }
    func storeUserID(userID: String) {
        print(userID)
        defaults.setObject(userID, forKey: "UserID")
    }
    func publicServiceCreation() {
        /*
         
         “category”: string (defaulted to “other”)
         “service”: {
         “title” : string
         “description” : big string
         “price” : float
         “status” : string (defaulted to “pending”)
         “due_date” : models.DateTimeField(null=True, blank=True)
         “created” : automatically set to the current server time
         “is_special” : boolean (defaulted to “false)
         }
         
         */
        
        if let myToken = defaults.objectForKey("userToken") as? String{
            print(myToken)
            let headers = [
                "Authorization": myToken
            ]
            let URL = "http://81.4.110.27/publicservice/"
            
            let category = "car Services"
            let service : [String: AnyObject] = [
                "title" : "public service 2",
                "description" : "this is a service description that will descripte the service with title public service 2",
                "price" : 12.1,
                "is_special" : false
            ]
            
            let parameters = [
                "category": category,
                "service": service
            ]
            
            Alamofire.request(.POST, URL, parameters: parameters as? [String : AnyObject], headers: headers, encoding: .JSON).responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
                    print(mydata)
                }
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
            }

        }
    }
    func getPublicService() {
   
        if let myToken = defaults.objectForKey("userToken") as? String{
            print(myToken)
            let headers = [
                "Authorization": myToken
            ]
            let URL = "http://81.4.110.27/publicservice/"
            
            Alamofire.request(.GET, URL, parameters: nil, headers: headers).responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
                    print(mydata)
                }
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
            }
            
        }
    }
    
    func deletionPublicService() {
        
        if let myToken = defaults.objectForKey("userToken") as? String{
            print(myToken)
            let headers = [
                "Authorization": myToken
            ]
            let URL = "http://81.4.110.27/puiblicservice/3/"
            
            Alamofire.request(.DELETE, URL, parameters: nil, headers: headers).responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
                    print(mydata)
                }
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
            }
            
        }
    }
    func placeABid() {
        if let myToken = defaults.objectForKey("userToken") as? String{
            print("token -> '\(myToken)'")
            let headers = [
                "Authorization": "\(myToken)"
            ]
            let URL = "http://81.4.110.27/bid/3/"
            let parameters = [
                "bid": 12
            ]
            
            Alamofire.request(.POST, URL, parameters: parameters, headers: headers, encoding: .JSON).responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
                    print(mydata)
                }
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
            }
            
        }
    }
    func publicServiceUpdate() {
        
        if let myToken = defaults.objectForKey("userToken") as? String{
            print(myToken)
            let headers = [
                "Authorization": myToken
            ]
            let URL = "http://81.4.110.27/publicservice/2/"
            
            let category = "Pet Services"
            let service : [String: AnyObject] = [
                "title" : "sjfbs.khdb",
                "description" : "this is a service description ksdhfks",
                "price" : 33.2,
                "is_special" : false
            ]
            
            let parameters = [
                "category": category,
                "service": service
            ]
            
            Alamofire.request(.PUT, URL, parameters: parameters as? [String : AnyObject], headers: headers, encoding: .JSON).responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
                    print(mydata)
                }
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
            }
            
        }
    }
    func offeredServiceCreation() {
        
        let URL = "http://81.4.110.27/offeredservice/"
        var imagesDictonaryList = [[String : AnyObject]]()
        var images = [UIImage]()
        for _ in 1...3 {
            images.append(UIImage(named: "profileImagePlaceholder")!)
        }
        let imagesData = imagesToBase64(images)
        for index in 0..<3 {
            var myDictionary = [String:AnyObject]()
            myDictionary["name"] = "\(index)"
            myDictionary["image"] = imagesData[index]
            imagesDictonaryList.append(myDictionary)
        }
        print(imagesDictonaryList)
        let service : [String: AnyObject] = [
            "title": "service 1 title",
            "description": "service 1 description",
            "price": "11"
        ]
        let parameters = [
            "category" :"Pets Services",
            "service": service,
            "serviceimage_set": imagesDictonaryList
        ]
        Alamofire.request(.POST, URL, parameters: parameters as? [String : AnyObject], encoding: .JSON).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            if let dataString = String(data: response.data!, encoding: NSUTF8StringEncoding) {
                print(dataString)
            }
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }
    func imagesToBase64(images: [UIImage]) -> [String]{
        var imagesData = [String]()
        for image in images {
            let imageData = UIImagePNGRepresentation(image)
            let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            imagesData.append(base64String)
        }
        return imagesData
    }

}